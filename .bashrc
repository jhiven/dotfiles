export $(envsubst < .env)

# start tnr setup
. /home/jhivens/.thunder/setup.sh
# end tnr setup
. "$HOME/.cargo/env"
