import re
from pprint import pprint
data = 'data.txt'

with open(data, 'r') as f:
    content = f.read()
    lines = content.split("\n")
    print('[')
    for line in lines:
        print('  {')
        nim, name = line.split('-')
        ip = f"10.99.99.{int(nim[-3:])}"

        print(f'    ip   = "{ip}"')
        print(f'    name = "VM-{line}"')
        print(f'    id   = "{nim}"')
        print('  },')
    print(']')

