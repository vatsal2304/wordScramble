//
//  ContentView.swift
//  word scramnle
//
//  Created by Funnmedia's Mac on 14/12/23.
//
import SwiftUI


struct ContentView: View {
    
    @State private var usedwords = [String]()
    @State private var rootWord = ""
    @State private var newword = ""
    @State private var score = 0
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    
    var body: some View {
        VStack{
            Text("score: \(score)")
            
            NavigationStack{
                List{
                    Section{
    //                    Text(rootWord)
                        TextField("Enter your word", text: $newword)
                            .textInputAutocapitalization(.never)
                    }
                    
                    Section{
                        ForEach(usedwords, id: \.self) { word in
                            Text(word)
                        }
                    }
                    Section{
                        Button("start game", action: startGame)
                    }
                }
                .navigationTitle(rootWord)
                .onSubmit(addNewWord)
                .onAppear(perform: startGame)
                .alert(errorTitle, isPresented: $showingError) { } message: {
                    Text(errorMessage)
                }
            }
        }
    }
//    func teststring(){
//        let word = "swift"
//        let checker = UITextChecker()
//
//        let range = NSRange(location: 0, length: word.utf16.count)
//        _ = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
//    }
    
    func addNewWord(){
        let answer = newword.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 2 else {
            wordError(title: "TOO SHORT!", message: "word should contain atleast 3 letters")
            return
        }
        
        guard isOriginal(word: answer) else{
            wordError(title: "word used already", message: "get more original! ")
            return
        }
        guard isPossible(word: answer) else{
            wordError(title: "word not possible", message: "you can't spell that word from '\(rootWord)'! ")
            return
        }
        
        guard isReal(word: answer) else{
            wordError(title: "word not recognized", message: "you can't just make them up, you know! ")
            return
        }
        usedwords.insert(answer, at: 0)
        newword = ""
    }
    
    func startGame(){
        usedwords.removeAll()
        score = 0
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm "
                return
            }
        }
//        fatalError("could not load start.txt from the bundle ")
    }
    
    func isOriginal(word: String) -> Bool{
        !usedwords.contains(word)
    }
    
    func isPossible(word: String) -> Bool{
        var tempWord = rootWord
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter){
                tempWord.remove(at: pos)
            }else{
                return false
            }
        }
        return true
    }

    func isReal(word: String) -> Bool{
        score += 1
        
        let checker = UITextChecker()
        
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
