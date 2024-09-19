import Cocoa
import Foundation
func load(_ file :String) -> String {
  let path = Bundle.main.path(forResource: file, ofType: nil)
  let str = try? String(contentsOfFile: path!, encoding: .utf8)
  return str!
}

let BearPic = load("Bear.txt")
let BisonPic = load("Bison.txt")
let FrogPic = load("Elephant.txt")
let RabbitPic = load("Rabbit.txt")
let asciiPics = [BearPic, BisonPic, FrogPic, RabbitPic]

func alignAsciiPics(_ asciiPics: [String]) -> String {
    var splitedPic: [[String]] = [];
    for i in 0..<asciiPics.count {
        splitedPic.append(asciiPics[i].components(separatedBy: "\n"))
    }
    
    splitedPic = splitedPic.sorted { $0.count > $1.count }
    var result = ""

    for i in 0..<splitedPic[0].count {
        for j in 0..<splitedPic.count{
            if splitedPic[j].count >= splitedPic[0].count - i + 2{
                let picLength = splitedPic[j].map { $0.count }.max() ?? 0
                let index = i - (splitedPic[0].count - splitedPic[j].count) - 2
                result += splitedPic[j][index].padding(toLength: picLength, withPad: " ", startingAt: 0)
            }
        }
        result += "\n"
    }
    result += "The Partying Animals!"
    return result
}

print(alignAsciiPics(asciiPics))

