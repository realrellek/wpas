#/bin/sh

# We need at least 2 parameters, the username under which wp is meant to run
# and the command line of wp.
if [ "$#" -lt 2 ]; then
  echo "Usage:"
  echo "  wpas <username> <...parameters>"
  exit
fi;

# Let's see if wp is even installed.
if ! command wp --info &> /dev/null; then
  echo "Could not find wp."
  exit 0
fi;

# desired user is the first parameter
RUNASUSER=$1

# Now discard the first parameter
shift

# And use all the rest to shove it into the wp command
COMMANDLINE=$@

# If you are not root, you probably don't even have permission to run sudo
# And also probably no need to run wpas.
if [ `id -u` -ne 0 ]; then
  echo "You are not root. You probably want to run wp directly."
  echo ""
  echo "  wp $COMMANDLINE"
  exit 0
fi;

# Let us see if the user even exists
if [ ! $(id -u "$RUNASUSER" 2> /dev/null) ]; then
  echo "User $RUNASUSER does not exist"
  exit 0
fi;

# build and execute the actual command
#
# do we have a sudo?
if command sudo -v &> /dev/null; then
  sudo -u $RUNASUSER -- wp $COMMANDLINE
  exit $?
# do we have a runuser (Linux only)?
elif ! command runuser --v &> /dev/null; then
  runuser -u $RUNASUSER wp $COMMANDLINE
  exit $?
# if not, we go the su route which is POSIX and should therefore be there
else
  su $RUNASUSER -s /bin/sh -c "wp $COMMANDLINE"
  exit $?
fi;
