#/bin/sh

# Let's see if wp is even installed (as per documentation).
if command wp --info &> /dev/null; then
  WPCOMMAND="wp"
# or maybe it's "wp-cli"?
elif command wp-cli --info &> /dev/null; then
  WPCOMMAND="wp-cli"
# or maybe it's "wp-cli.phar"?
elif command wp-cli.phar --info &> /dev/null; then
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
  exit
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
  exit 2
fi;

# Let us see if the user even exists
if [ ! $(id -u "$RUNASUSER" 2> /dev/null) ]; then
  echo "User $RUNASUSER does not exist"
  exit 3
fi;

# build and execute the actual command
#
# do we have a sudo?
if command sudo -v &> /dev/null; then
  sudo -u $RUNASUSER -- $WPCOMMAND $COMMANDLINE
# do we have a runuser (Linux only)?
elif command runuser --v &> /dev/null; then
  runuser -u $RUNASUSER -- $WPCOMMAND $COMMANDLINE
# if not, we go the su route which is POSIX and should therefore be there
else
  su $RUNASUSER -s /bin/sh -c "$WPCOMMAND $COMMANDLINE"
fi;

exit $?
