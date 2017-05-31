# Auto-activate conda environments
function conda_auto_env() {
  if [ -e "environment.yml" ]; then
    ENV=$(head -n 1 environment.yml | cut -f2 -d ' ')
    # Check we're not already in the environment
    if [[ $PATH != *$ENV* ]]; then
      echo "Activating ${ENV} environment..."
      . activate $ENV
      if [ $? -ne 0 ]; then
        # create environment and activate
        echo "Conda env ${ENV} doesn't exist"
        echo "Creating ${ENV}"
        conda env create -f environment.yml
        . activate $ENV
      fi
    fi
  fi
}
