#!/bin/bash

#Путь для джавы (если нужна для приложения)
export JAVA_HOME=/opt/java
export PATH=${JAVA_HOME}/bin:${PATH}

#PROGRAM_HOME домашняя директория программы (для запуска\остановки)
export PROGRAM_HOME=/opt/tomcat8

#PROGRAM_USER пользователь из под которого запускается прогамма
export PROGRAM_USER=root

#PROGRAM_USAGE сообщение-подсказка при обращении к программе
PROGRAM_USAGE="Usage: $0 {\e[00;32mstart\e[00m|\e[00;31mstop\e[00m|\e[00;31mkill\e[00m|\e[00;32mstatus\e[00m|\e[00;31mrestart\e[00m}"

#SHUTDOWN_WAIT время ожидания закрытия перед тем как убить запущенный процесс
SHUTDOWN_WAIT=5

program_pid() {
    echo $(ps -fe | grep ${PROGRAM_HOME} | grep -v grep | tr -s " "|cut -d" " -f2)
}

start() {
    pid=$(program_pid)
    if [ -n "$pid" ]
        then
        echo -e "\e[00;31mProgram is already running (pid: $pid)\e[00m"
    else
        echo -e "\e[00;32mStarting Program\e[00m"
        if [ `user_exists ${PROGRAM_USER}` = "1" ]
        then
            /bin/su ${PROGRAM_USER} -c ${PROGRAM_HOME}/bin/start.sh
        else
            echo -e "\e[00;31mProgram user ${PROGRAM_USER} does not exists. Starting with $(id)\e[00m"
            sh ${PROGRAM_HOME}/bin/startup.sh
        fi
        status
  fi
  return 0
}

status(){
          pid=$(program_pid)
          if [ -n "${pid}" ]
            then echo -e "\e[00;32mProgram is running with pid: ${pid}\e[00m"
          else
            echo -e "\e[00;31mProgram is not running\e[00m"
            return 3
          fi
}

terminate() {
    echo -e "\e[00;31mTerminating Program\e[00m"
    kill -9 $(program_pid)
}

stop() {
  pid=$(program_pid)
  if [ -n "$pid" ]
  then
    echo -e "\e[00;31mStoping Program\e[00m"
    ${PROGRAM_HOME}/bin/stop.sh
    let kwait=$SHUTDOWN_WAIT
    count=0;

    until [ -z "${pid}" ] || [ $count -gt $kwait ]
    do
      echo -n -e "\n\e[00;31mwaiting for processes to exit\e[00m";
      echo
      sleep 1
      pid=$(program_pid)
      let count=$count+1;
    done

    if [ $count -gt $kwait ]; then
      echo -n -e "\n\e[00;31mkilling processes didn't stop after $SHUTDOWN_WAIT seconds\e[00m"
      terminate
    fi
  else
    echo -e "\e[00;31mProgram is not running\e[00m"
  fi

  return 0
}

user_exists(){
        if id -u $1 >/dev/null 2>&1; then
        echo "1"
        else
            echo "0"
        fi
}

case $1 in
    start)
        start
    ;;
    stop)
        stop
    ;;
    restart)
        stop
        start
    ;;
    status)
        status
        exit $?
    ;;
    kill)
        terminate
    ;;
    *)
        echo -e ${PROGRAM_USAGE}
    ;;
esac
exit 0
