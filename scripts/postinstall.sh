if which -s katon; then
  katon start
else
  echo 'Please install katon globally:'
  echo 'npm install -g katon'
fi