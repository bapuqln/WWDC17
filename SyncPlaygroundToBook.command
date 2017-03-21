#copy The main runner
cp /Users/Salman/Library/Mobile\ Documents/iCloud~com~apple~Playgrounds/Documents/WWDC17.playground/Contents.swift /Users/Salman/Library/Mobile\ Documents/iCloud~com~apple~Playgrounds/Documents/Vision.playgroundbook/Contents/Chapters/Chapter1.playgroundchapter/Pages/Page1.playgroundpage/Contents.swift
#Copy sources
cp -R /Users/Salman/Library/Mobile\ Documents/iCloud~com~apple~Playgrounds/Documents/WWDC17.playground/Sources /Users/Salman/Library/Mobile\ Documents/iCloud~com~apple~Playgrounds/Documents/Vision.playgroundbook/Contents/Chapters/Chapter1.playgroundchapter/Pages/Page1.playgroundpage/

#Copy resources
cp -R /Users/Salman/Library/Mobile\ Documents/iCloud~com~apple~Playgrounds/Documents/WWDC17.playground/Resources/ /Users/Salman/Library/Mobile\ Documents/iCloud~com~apple~Playgrounds/Documents/Vision.playgroundbook/Contents/Chapters/Chapter1.playgroundchapter/Pages/Page1.playgroundpage/Resources/

#Touch to signal iCloud drive that we need to update -> pushes to iPad for testing!
touch /Users/Salman/Library/Mobile\ Documents/iCloud~com~apple~Playgrounds/Documents/Vision.playgroundbook 
