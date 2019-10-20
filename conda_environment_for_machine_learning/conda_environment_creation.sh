#!/bin/sh

echo "Install conda? (yes|no) (default: no)"
read CONDA_INSTALL
if [ "$CONDA_INSTALL" = "yes" ]; then
    # prerequisites
    echo "==== Installing conda prerequisites ===="
    apt-get install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6

    #Download
    echo "==== Downloading Conda ===="
    cd $HOME/Downloads && { curl -O https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh ; cd -; }

    #Install conda
    echo "==== Installing Conda ===="
    bash ~/Downloads/Anaconda3-2019.10-Linux-x86_64.sh
fi

echo "Enter environment name (default deeplearning):"
read ENVIRONMENT_NAME
if [ -z "$ENVIRONMENT_NAME" ]; then
    ENVIRONMENT_NAME="deeplearning"
fi

echo "Enter python version (default 3.6.6):"
read PYTHON_VERSION
if [ -z "$PYTHON_VERSION" ]; then
    PYTHON_VERSION="3.6.6"
fi

echo "Enter tensorflow support gpu (yes|no) (default: no)"
read TF_GPU

#Install packages
echo "==== Installing packages ===="
CONDA_ENVIRONMENT_COMMAND="conda create --name $ENVIRONMENT_NAME python=$PYTHON_VERSION numpy scipy matplotlib pandas statsmodels scikit-learn"

if [ "$TF_GPU" = "yes" ]; then
    CONDA_ENVIRONMENT_COMMAND="$CONDA_ENVIRONMENT_COMMAND && source activate $ENVIRONMENT_NAME && pip install tensorflow-gpu"
else
    CONDA_ENVIRONMENT_COMMAND="$CONDA_ENVIRONMENT_COMMAND && source activate $ENVIRONMENT_NAME && pip install tensorflow"
fi

CONDA_ENVIRONMENT_COMMAND="$CONDA_ENVIRONMENT_COMMAND && conda install pytorch torchvision cudatoolkit=10.1 -c pytorch"

gnome-terminal --tab -- bash -c "$CONDA_ENVIRONMENT_COMMAND"
exit


