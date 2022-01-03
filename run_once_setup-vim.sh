#!/bin/bash
# Create directories for use with vim
mkdir -p ~/.vim/tmp/undo
mkdir -p ~/.vim/tmp/backup
mkdir -p ~/.vim/tmp/swp

# Create cron job to purge undofiles if source file is deleted
crontab=crontab -l 2>/dev/null # Gets cron jobs
if [ $? -eq 0 ]; then
    # If crontab exists, check for the script
    exists=echo $crontab | grep -q 'purge_vim_undodir'
else
    # If crontab is empty, the script job doesn't exist
    exists=false
fi

if [ $exists = false ]; then
    # If the script wasn't found in cron jobs, create job
    (crontab -l 2>/dev/null; echo "5 8 * * 1 $HOME/bin/purge_vim_undodir $HOME/.vim/tmp/undo") | crontab -
fi
