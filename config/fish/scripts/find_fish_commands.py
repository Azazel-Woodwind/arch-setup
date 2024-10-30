import argparse

parser = argparse.ArgumentParser()
parser.add_argument("command")  # positional argument

args = parser.parse_args()

command = args.command

command_indices = []
inNewSegment = True
currentCommand = ""
enders = {"|", "&", ";", ")", " ", "\n"}
newSegmentStarts = {"|", "&", ";", "(", "\n"}
scopeStarters = {"function", "if", "while", "for"}
inFunction = False
stringStarter = None
quotes = {"'", '"'}
startingIndex = None
scopeEnders = 0
for i, c in enumerate(command):
    if stringStarter is None:
        if c in quotes:
            stringStarter = c
    else:
        if c == stringStarter:
            stringStarter = None
        continue
    
    if c in enders:
        if inFunction:
            string = command[startingIndex:i]
            if string in scopeStarters:
                scopeEnders += 1
            elif string == "end":
                scopeEnders -= 1
                if scopeEnders == 0:
                    inFunction = False
                    startingIndex = None
        elif startingIndex is not None:
            string = command[startingIndex:i]
            if string == "function":
                inFunction = True
                scopeEnders = 1
            else:
                command_indices.append((startingIndex, i))
                
            startingIndex = None
    else:
        if inNewSegment:
            startingIndex = i
            inNewSegment = False
            
    if c in newSegmentStarts:
        inNewSegment = True
        startingIndex = None
    
if startingIndex is not None and not inFunction:
    command_indices.append((startingIndex, len(command)))
    
for start, end in command_indices:
    print(f"{start};{end - 1}")    