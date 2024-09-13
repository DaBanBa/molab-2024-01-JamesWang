import Cocoa

let moonPhases = ["🌑", "🌒", "🌓", "🌔", "🌕"]

func printMoon(){
    printBlankLn();
    for row in 1...10{
        printMoonLn(row: row)
    }
    for row in 1...9{
        printMoonLnRvrs(row: row)
    }
    printBlankLn();
}

func printBlankLn(){
    var line = ""
    let leadingSpaces = 22
    line += String(repeating: moonPhases[0], count: leadingSpaces)
    print(line)
}

func printMoonLn(row: Int) {
    let totalWidth = 11
    let phasesCount = moonPhases.count
    
    var line = ""
    line += moonPhases[0]
    let leadingSpaces = totalWidth - row - 1
    line += String(repeating: moonPhases[0], count: leadingSpaces)
    
    for i in 0..<row {
        let phaseIndex = i
        if phaseIndex >= phasesCount - 1{
            line += moonPhases[4]
        } else {
            line += moonPhases[phaseIndex + 1]
        }
    }
    
    for i in 0..<row {
        let phaseIndex = row - i
        if phaseIndex >= 5{
            line += moonPhases[4]
        } else {
//            print(phaseIndex)
            line += moonPhases[phaseIndex]
        }
    }
    
    line += String(repeating: moonPhases[0], count: leadingSpaces)
    line += moonPhases[0]
    
    print(line)
}

func printMoonLnRvrs(row: Int) {
    let rvrsRow = 9 - row + 1
    let totalWidth = 11
    let phasesCount = moonPhases.count
    
    var line = ""
    line += moonPhases[0]
    let leadingSpaces = totalWidth - rvrsRow - 1
    line += String(repeating: moonPhases[0], count: leadingSpaces)
    
    for i in 0..<rvrsRow {
        let phaseIndex = i
        if phaseIndex >= phasesCount - 1{
            line += moonPhases[4]
        } else {
            line += moonPhases[phaseIndex + 1]
        }
    }
    
    for i in 0..<rvrsRow {
        let phaseIndex = rvrsRow - i
        if phaseIndex >= 5{
            line += moonPhases[4]
        } else {
            line += moonPhases[phaseIndex]
        }
    }
    
    line += String(repeating: moonPhases[0], count: leadingSpaces)
    line += moonPhases[0]
    
    print(line)
}

printMoon()
