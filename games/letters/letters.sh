#!/bin/sh

# Copyright (c) 2016, Jakob Sliczniak
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
# 
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
# 
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
# PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# in case it's a function
unset trap
unset kill
unset r
unset lcap

# going to use the PATH to find it, in case it's a function
unset stty
unset dd

# Take the long SysV style terminal capabilty as the first arg and the
# BSD style two character name as the second, then the rest of the args
# are for that capability. The default tput for FreeBSD only knows the
# short two char ones execpt for some special ones like clear, which can
# do too much like pause for a second. Also it seems to understand colors
# but really returns co (columns) instead because it only matches on first
# two characters and ignores the rest. This specific example is why colors 
# (Co) is not used at all. If the terminal description returned nothing for
# Co (because it was simply an amber/black terminal for example) and then
# colors was looked-up, it could return columns (co) on some BSD-likes, which
# would be say 80. Instead escapes are simply used to get the bright and
# normal typical colors (Black Red Green Yellow Blue Magenta Cyan White)
# escape sequences. In the case of a B&W terminal they will all be empty
# strings and then be split into an empty array in the awk script. There
# using any entry will just use an empty string and not change attributes
# at all.
#
# Darwin understands most of the short names as well as the long ones. Be
# sure to use the default system tput because there can be other ones that
# are installed for example from ncurses that behave differently than the
# system one. Also there were some older versions of FreeBSD that would
# not return an error code for an unkown capability, instead they would
# simply not print anything.
#
# So first try the BSD capname then if that fails the SysV one.
tput() {
	lcap="$1"; shift

	NCURSES_NO_PADDING=1 /usr/bin/tput "$@" 2>/dev/null && return

	shift

	NCURSES_NO_PADDING=1 /usr/bin/tput "$lcap" "$@"
}

# tput quiet - turns out I pretty much never want to see an error message
tpq() {
	tput "$@" 2>/dev/null
}

# want to use the default stty command, but the BSD compat one on Solaris,
# the SysV stty does not understand cbreak, you are supposed to use something
# like -icanon min 1 instead!
PATH="/usr/ucb:/bin"

# exit status
r=2

# smcup mode
unset s
unset hi
unset lo
unset cl
unset vb
unset colors

case "$1" in
  *)
	#shift

	# flash_screen    flash      vb        visible bell
	vb=`tput flash vb 2>/dev/null` || vb=`tput bel bl 2>/dev/null`

	# I can't figure-out how to do SGR#22, so just reset all attributes
	# instead of sgr22 followed by sgr0 like for flash_screen above.
	hi=`tpq sgr0 me`

	# bold
	lo=`tpq bold md`

	# bgc black
	s=`tpq setab AB 0`

	# It would be really nice if I could start this with
	#   setaf AF 0 + bold md
	# for grey on black, but some terminals don't use bright colors for
	# bold text and then you get black on black which is unreadable.
	cl=`tpq setaf AF 7`
	colors="$hi$s$cl $s$cl$lo"
	cl=`tpq setaf AF 6`
	colors="$colors $hi$s$cl $s$cl$lo"
	cl=`tpq setaf AF 5`
	colors="$colors $hi$s$cl $s$cl$lo"
	cl=`tpq setaf AF 4`
	colors="$colors $hi$s$cl $s$cl$lo"
	cl=`tpq setaf AF 3`
	colors="$colors $hi$s$cl $s$cl$lo"
	cl=`tpq setaf AF 2`
	colors="$colors $hi$s$cl $s$cl$lo"
	cl=`tpq setaf AF 1`
	colors="$colors $hi$s$cl $s$cl$lo"

	# Now the sensible stuff for the variables
	hi=`tput smso so 2>/dev/null`
	lo="`tput rmso se 2>/dev/null`$s"
	cl=`tput clear cl 2>/dev/null`

	s=1
	;;
esac

# return controlling terminal to cooked mode
cooked () {
	stty -cbreak echo

	case "$s" in
	  1)
		# cursor_normal
		tpq cnorm ve

		# must exit_ca_mode first
		tput rmcup te 2>/dev/null

		# reset attributes
		tput sgr0 me 2>/dev/null
		;;
	esac

	# reset SIGINT to default handling
	trap 2

	# reset EXIT handling
	trap 0
}

# bash EXIT trap - must use zero so other shells do not complain
# this also works on some other shells
trap cooked 0

# SIGINT is special case, need to send it to myself again after resetting the
# handler, cooked() does that.
trap 'cooked; kill -2 $$' 2

# SIGQUIT (^/ - dump core and exit) and SIGTERM
trap cooked 3 15

# don't need to worry about SIGHUP, means terminal is detached anyway
# won't care about bugs in the shell, like SIGSEGV, cause can it eve
# handle that reliably? Also then I don't need to worry about if kill
# can use signal names and what the signal numbers are.

# put terminal in rare mode
stty cbreak -echo

case "$s" in
  1)
	# must set_a_background black first
	tput setab AB 0 2>/dev/null

	# foreground white
	tpq setaf AF 7

	# cursor_invisible
	tpq civis vi

	# enter_ca_mode
	tput smcup ti 2>/dev/null
	;;
esac

# wish I could just use: /usr/bin/fold -1 but it buffers stdout
# oh yeah, print one byte from stdin to stdout, then a newline
fold() {
	# echo will fail when awk quits, throw away the error message
	while echo 2>/dev/null; do
		dd bs=1 count=1 2>/dev/null
	done
}

# awk on Solaris does not have funtions or rand(), use nawk
awk() {
	if [ -x /usr/bin/nawk ]; then
		/usr/bin/nawk "$@"
	else
		/usr/bin/awk "$@"
	fi
}


# use fold so each character is it's own line for awk 
fold | awk \
-f letters.awk \
  ${s:+hi="$hi"} ${s:+lo="$lo"} ${s:+cl="$cl"} \
  ${s:+vb="$vb"} ${s:+colors="$colors"} "$@"

r=$?

# also resets EXIT handler, so does not get called twice
cooked

exit $r
