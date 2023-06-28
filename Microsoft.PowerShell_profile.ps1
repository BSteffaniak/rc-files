function nvims {
  nvim -c "lua Handle_load_session()" $args
}

function devship {
  airship --use-links $args
}
