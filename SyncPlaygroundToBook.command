#copy The main runner
cp /Users/Salman/Library/Mobile\ Documents/iCloud~com~apple~Playgrounds/Documents/IntoScene.playground/Contents.swift "/Users/Salman/Library/Mobile Documents/iCloud~com~apple~Playgrounds/Documents/Vision.playgroundbook/Contents/Chapters/Vision.playgroundchapter/Pages/Welcome.playgroundpage"

cp /Users/Salman/Library/Mobile\ Documents/iCloud~com~apple~Playgrounds/Documents/SeeingSwingSK.playground/Contents.swift "/Users/Salman/Library/Mobile Documents/iCloud~com~apple~Playgrounds/Documents/Vision.playgroundbook/Contents/Chapters/Vision.playgroundchapter/Pages/SeeingSwing.playgroundpage"

cp /Users/Salman/Library/Mobile\ Documents/iCloud~com~apple~Playgrounds/Documents/BlindSwingSK.playground/Contents.swift "/Users/Salman/Library/Mobile Documents/iCloud~com~apple~Playgrounds/Documents/Vision.playgroundbook/Contents/Chapters/Vision.playgroundchapter/Pages/BlindSwing.playgroundpage"
#nuke chaneges because they are now invalid
rm -rf "/Users/Salman/Library/Mobile Documents/iCloud~com~apple~Playgrounds/Documents/Vision.playgroundbook/Edits"

#Touch to signal iCloud drive that we need to update -> pushes to iPad for testing!
touch /Users/Salman/Library/Mobile\ Documents/iCloud~com~apple~Playgrounds/Documents/Vision.playgroundbook 
