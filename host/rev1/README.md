
## Install necessary libraries

python -m pip install -r host/requirements.txt

if you ever use multiple Pythons (Windows Store Python, Anaconda, system Python), always use python -m pip ... not plain pip.

## Run python program (host)

Run host using:
'''
python la_host.py --port COMx self-test
'''

## Soak test

Run soak test using:
'''
python la_host.py --port COMx --runs 1000 --expect <00/FF/any/...> soak-test
'''