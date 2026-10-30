# sports_ball_classifer
Install deps and activate the venv
uv sync
source .venv/bin/activate

Fetch grayscale Simpsons-MNIST (sparse checkout into data/train and data/test)
make get-grayscale-data

Version the data with DVC (run here; --subdir because the repo root is git-tracked)
dvc init --subdir
dvc remote add -d myremote /tmp/dvcstore   # swap for S3/Blob as needed
dvc add data
dvc push

git add .
git commit -m "Add first version of data"
git push

In bash:
export MLFLOW_FLASK_SERVER_SECRET_KEY='mlflowsk'

Start MLflow
mlflow server --app-name basic-auth --backend-store-uri sqlite:///mlflow.db --port 5000

Point ZenML at MLflow
source .venv/bin/activate
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES # This is required if you are on a Mac # spellchecker:disable-line
zenml login --local

# sports ball dataset
pipx install kaggle

If you have kaggle setup locally, skip this:

Generate new kaggle api key token 
run at root: mkdir -p ~/.kaggle && echo <YOUR_KAGGLE_API_KEY> > ~/.kaggle/access_token && chmod 600 ~/.kaggle/access_token

Download all rgb ball images:

make get-ball-data

Version data:

dvc add data
dvc push

git add .
git commit -m "New data version, RGB images"
git push