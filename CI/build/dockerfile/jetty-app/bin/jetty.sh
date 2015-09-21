#!/bin/bash  
#===============================================================================
#
#        AUTHOR: shibaolan (), shibaolan@kingdee.com
#  ORGANIZATION: 
#       CREATED: 2012��09��21�� 11ʱ54��26�� CST
#      REVISION:  ---
#===============================================================================
BIN_HOME=`pwd`
globalfile="/kingdee/jetty/etc/global.properties"
if [ -r "$globalfile" ] && [ -f "$globalfile" ]
then
   source $globalfile
else
   echo "global properties ($globalfile)not exist! exit now"
   exit 1
fi




##################################################
# Try to find this script's configuration file,
# but only if no configurations were given on the
# command line.
##################################################
if [ -z "$JETTY_CONF" ] 
then
  if [ -f $DOMAIN_HOME/etc/jetty.conf ]
  then
    JETTY_CONF=$DOMAIN_HOME/etc/jetty.conf
  elif [ -f "$DOMAIN_HOME/etc/jetty.conf" ]
  then
    JETTY_CONF=$DOMAIN_HOME/etc/jetty.conf
  fi
fi

##################################################
# Get the list of config.xml files from jetty.conf
##################################################
if [ -z "$CONFIGS" ] && [ -f "$JETTY_CONF" ] && [ -r "$JETTY_CONF" ] 
then
  while read -r CONF
  do
    if expr "$CONF" : '#' >/dev/null ; then
      continue
    fi

    if [ -d "$CONF" ] 
    then
      # assume it's a directory with configure.xml files
      # for example: /etc/jetty.d/
      # sort the files before adding them to the list of CONFIGS
      for file in "$CONF/"*.xml
      do
        if [ -r "$FILE" ] && [ -f "$FILE" ] 
        then
          CONFIGS+=("$FILE")
        else
          echo "** WARNING: Cannot read '$FILE' specified in '$JETTY_CONF'" 
        fi
      done
    else
      # assume it's a command line parameter (let start.jar deal with its validity)
      CONFIGS+=("$CONF")
    fi
  done < "$JETTY_CONF"
fi

##################################################
# Setup JAVA if unset
##################################################
if [ -z "$JAVA" ]
then
JAVA=$JAVA_HOME/bin/java
fi

usage()
{
    echo "Usage: ${0##*/} [-d] {start|stop|run|restart|check|supervise} [ CONFIGS ... ] "
    exit 1
}

[ $# -gt 0 ] || usage
ACTION=$1
running()
{
  local PID=$(cat "$1" 2>/dev/null) || return 1
  kill -0 "$PID" 2>/dev/null
}

##################################################
# Set tmp if not already set.
##################################################
TMPDIR=${TMPDIR:-/tmp}

#####################################################
# Find a PID for the pid file
#####################################################
if [ -z "$JETTY_PID" ] 
then
  JETTY_PID="$JETTY_RUN/jetty.pid"
fi
########20120921
#####################################################
# Add jetty properties to Java VM options.
#####################################################
#JAVA_OPTIONS+=("-Djetty.home=$JETTY_HOME" "-Djava.io.tmpdir=$TMPDIR")

#####################################################
# This is how the Jetty server will be started
#####################################################
#DATE=`date +%Y%m%d%H%M`
#GC_LOG_FILE_NAME=jvm_gc_$DATE.log
JVM_MEM_OPTIONSFirst="-Xmx2g -Xms256m -XX:PermSize=128m -XX:MaxPermSize=368m "

#####################################################
JVM_MEM_OPTIONS="$JVM_MEM_OPTIONSFirst $JVM_MEM_OPTIONS"
JETTY_START=$JETTY_HOME/start.jar
[ ! -f "$JETTY_START" ] && JETTY_START=$JETTY_HOME/lib/start.jar
RUN_ARGS=($JVM_MEM_OPTIONS  ${JAVA_OPTIONS[@]} -jar "$JETTY_START" OPTIONS=All $DOMAIN_HOME/etc/jetty.xml   $DOMAIN_HOME/etc/jetty-deploy.xml $DOMAIN_HOME/etc/jetty-logging.xml )
RUN_CMD=("$JAVA" ${RUN_ARGS[@]})

##################################################
# Do the action
##################################################
DATEP=`date +%Y-%m-%d-%T`
case "$ACTION" in
  start)
    cd $DOMAIN_HOME
    echo -n "Starting Jetty: "

    if (( NO_START )); then 
      echo "Not starting jetty - NO_START=1";
      exit
    fi

    if type start-stop-daemon > /dev/null 2>&1 
    then
      unset CH_USER
      if [ -n "$JETTY_USER" ]
      then
        CH_USER="-c$JETTY_USER"
      fi
      if start-stop-daemon -S -p"$JETTY_PID" $CH_USER -d"$JETTY_HOME" -b -m -a "$JAVA" -- "${RUN_ARGS[@]}" --daemon
      then
        sleep 1
        if running "$JETTY_PID"
        then
          echo "OK"
        else
          echo "FAILED"
        fi
      fi

    else

      if [ -f "$JETTY_PID" ]
      then
        if running $JETTY_PID
        then
          echo "Already Running!"
          exit 1
        else
          # dead pid file - remove
          rm -f "$JETTY_PID"
        fi
      fi

      if [ "$JETTY_USER" ] 
      then
        touch "$JETTY_PID"
        chown "$JETTY_USER" "$JETTY_PID"
        # FIXME: Broken solution: wordsplitting, pathname expansion, arbitrary command execution, etc.
        su - "$JETTY_USER" -c "
          ${RUN_CMD[*]} --daemon &
          disown \$!
          echo \$! > '$JETTY_PID'"
      else
        echo "${RUN_CMD[@]}" &
        "${RUN_CMD[@]}" &
        disown $!
        echo $! > "$JETTY_PID"
      fi

      echo "STARTED Jetty `date`" 
    fi

    ;;

  stop)
    cd $DOMAIN_HOME
    echo -n "Stopping Jetty: "
    if type start-stop-daemon > /dev/null 2>&1; then
      start-stop-daemon -K -p"$JETTY_PID" -d"$JETTY_HOME" -a "$JAVA" -s HUP
      
      TIMEOUT=3
      while running "$JETTY_PID"; do
        if (( TIMEOUT-- == 0 )); then
          start-stop-daemon -K -p"$JETTY_PID" -d"$JETTY_HOME" -a "$JAVA" -s KILL
        fi

        sleep 1
      done

      rm -f "$JETTY_PID"
      echo OK
    else
      PID=$(cat "$JETTY_PID" 2>/dev/null)
      kill "$PID" 2>/dev/null
      
      TIMEOUT=3
      while running $JETTY_PID; do
        if (( TIMEOUT-- == 0 )); then
          kill -KILL "$PID" 2>/dev/null
        fi

        sleep 1
      done

      rm -f "$JETTY_PID"
      echo OK
    fi
    ;;

  restart)
      JETTY_SH=jetty.sh
      echo `pwd`
      sh "$JETTY_SH" stop
      sh "$JETTY_SH" start

    ;;

  supervise)
    #
    # Under control of daemontools supervise monitor which
    # handles restarts and shutdowns via the svc program.
    #
    exec "${RUN_CMD[@]}"

    ;;

  run|demo)
    echo "Running Jetty: "

    if [ -f "$JETTY_PID" ]
    then
      if running "$JETTY_PID"
      then
        echo "Already Running!"
        exit 1
      else
        # dead pid file - remove
        rm -f "$JETTY_PID"
      fi
    fi

    exec "${RUN_CMD[@]}"

    ;;

  check)
    echo "Checking arguments to Jetty: "
    echo "JETTY_HOME     =  $JETTY_HOME"
    echo "JETTY_CONF     =  $JETTY_CONF"
    echo "JETTY_RUN      =  $JETTY_RUN"
    echo "JETTY_PID      =  $JETTY_PID"
    echo "JETTY_PORT     =  $JETTY_PORT"
    echo "JETTY_LOGS     =  $JETTY_LOGS"
    echo "START_INI      =  $START_INI"
    echo "CONFIGS        =  ${CONFIGS[*]}"
    echo "JAVA_OPTIONS   =  ${JAVA_OPTIONS[*]}"
    echo "JAVA           =  $JAVA"
    echo "CLASSPATH      =  $CLASSPATH"
    echo "RUN_CMD        =  ${RUN_CMD[*]}"
    echo
    
    if [ -f "$JETTY_RUN/jetty.pid" ]
    then
      echo "Jetty running pid=$(< "$JETTY_RUN/jetty.pid")"
      exit 0
    fi
    exit 1

    ;;

  *)
    usage

    ;;
esac

exit 0
