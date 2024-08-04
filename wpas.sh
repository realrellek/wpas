#!/bin/sh

# Let's see if wp is even installed (as per documentation).
if command -v wp > /dev/null; then
  WPCOMMAND="wp"
# or maybe it's "wp-cli"?
elif command -v wp-cli > /dev/null; then
  WPCOMMAND="wp-cli"
# or maybe it's "wp-cli.phar"?
elif command -v wp-cli.phar > /dev/null; then
  WPCOMMAND="wp-cli.phar"
# Guess it's not installed <shrug emote>
else
  echo "Could not find wp."
  exit 1
fi;

# We need at least 2 parameters, the username under which wp is meant to run
# and the command line of wp.
if [ "$#" -lt 2 ]; then
  echo "Usage:"
  echo "  wpas <username> <...parameters>"
  exit 2
fi;

# desired user is the first parameter
RUNASUSER=$1

# Now discard the first parameter
shift

# And use all the rest to shove it into the wp command
COMMANDLINE=$@

# If you are not root, you probably don't even have permission to run sudo
# And also likely no need to run wpas.
if [ `id -u` -ne 0 ]; then
  echo "You are not root. You probably want to run wp directly."
  echo ""
  echo "  $WPCOMMAND $COMMANDLINE"
  exit 3
fi;

# Let us see if the user even exists
if [ ! $(id -u "$RUNASUSER" 2> /dev/null) ]; then
  echo "User $RUNASUSER does not exist"
  exit 4
fi;

# build and execute the actual command
#
# do we have a sudo?
command -v sudo > /dev/null
if [ $? -eq "0" ]; then
  sudo -u $RUNASUSER -- $WPCOMMAND $COMMANDLINE
# do we have a runuser (Linux only)?
else
  # do we have a runuser (Linux only)?
  command -v runuser > /dev/null
  if [ $? -eq 0 ]; then
    runuser -u $RUNASUSER -- $WPCOMMAND $COMMANDLINE
  else
    # if not, we go the su route which is POSIX and should therefore be there
    su $RUNASUSER -s /bin/sh -c "$WPCOMMAND $COMMANDLINE"
  fi;
fi;

exit $?
