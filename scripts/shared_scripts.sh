#!/bin/bash

# Given the name of a Homebrew formula, check if its installed and if not, install it.
fetch_brew_dependency() {
    FORMULA_NAME=$1

    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        echo "Fetching Brew dependency: '$FORMULA_NAME'."
        if brew ls --versions $FORMULA_NAME > /dev/null; then
            echo "Dependency '$FORMULA_NAME' is already installed, continuing ..."
        else
            echo "Dependency '$FORMULA_NAME' is not installed, installing via Homebrew ..."
            brew install $FORMULA_NAME
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo 'Linux is unsupported at the moment'
    elif [[ "$OSTYPE" == "win32" ]]; then
        echo 'win32 is unsupported at the moment'
    else
        echo 'your OS is unsupported'
            # Unknown.
    fi
}
