//
//  DatabaseTestView.swift
//  Amazon Prime Video Copy
//
//  Created by Salvatore Manna on 09/12/21.
//

import SwiftUI

extension String {
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else {return nil}
        return String(data: data, encoding: .utf8)
    }
    
}


struct DatabaseTestView: View, HomeModelDelegate {
    
    
    var homeModel = HomeModel()
    
    @State var temporaryName = ""
    
//    @State var str = "/"
    
    @State var str = "iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAAXNSR0IArs4c6QAABfJJREFUeJztm0FrG0cYhp\\/KTojArlhTl1SE4FSYJAiTYAo2xZHxoSeTq0+FnHPLf+ixl97aa6G95Bpy6qE4NaGH0CQEU0wqYpx0E6JGi5CJEkm2elBnNVrNrGZmd9VC\\/YLxWjs7O+8z3\\/ft7FoLJzrR\\/1ofTPqE127d7E3\\/tjvy+c\\/37k18LADTkzrRRqXS6y6XAVhdWVE16cHkQWQOYKNS6UHf9E7nEABvfn6knQRloiAyAyAbh77p1u6r\\/s4izBUK1BuNsL03P09Qqw2B6C6X+eWbbzMFkQmAjUqlJxuXlfdmmCsUAMLfAPVGY6itiJiNSqWXZTTk0u5QZ36uUCDvzWiPmysUhoCIY7vL5TCaslCqAOLMm0oG0Qr6NWN1ZSUzCKkBUJmPzuqNy1fD7bX1ddbW17X9TQpCKgCu3bqpNK\\/T978\\/CrcFCBUMkTI\\/ve4XzywgJAZw7dbNcEAm5oUOZv8a+SwK4cblq+S9GfLeTNh32hASAZAHYmM+Trq0uOM\\/ywSCMwA554VMzIs68NXXP7Kzvc3O9rZRe6G0IaRSA1rBYeKZN9Ed\\/xmgXkm6ygmAPPuiSieRTRQICJBOFFgDUIW+rYQh+WpgmwppKVEKyKEom3GVSU2AdKMglRoQt8TVSRUFpscA7HQOU6kFVgBUqz0X80mkqgdJosAKgHigoRuQq2zTRz6nWCW6yhiAvOJLS0ng3bh8deh41ygwBqB6jieu\\/S75HJXrsVvlJe5Wn3K3+tTpeKcimOZCJA19ufo5AG8+mrM+1giAXPzEcz3dyi9JPieJoM3SIpulRes0SP2JUFLZQki6BLcCsHZKf8nLaqWWtZwiQF6JqZQkDVyOB\\/e69J9JgSQQ5DSwvRxaA7hevKDdl1ZBs5X8\\/wVbjQWgu\\/szMfhvpIKtUk+BpMXQFkKS2QcHAEGtRis4NH4Q4jKLphCSmgfHCNgqLwHw3f0d5SDSCGVdH\\/VGI\\/yRFdRq1ucARwAmJ0tjXTCJmjAWwB\\/t98rPRRTc3n2inRVZroMXd30i7W7vPhlp4zr7YADguHmkvNNyiYIkM7hVXhqCbjOOOCW6CoinQfKATKLBVKq+ZAhJzUNCAHH3BtA3cL14YeiqERcFsuE4gFvlJdrNpvMzAFljAXxy+giaOe3J2s0m7WZTmZtRCRDi6mFqOKqgVmOztAigHFez2TTuyygCFvJdaKqbioG0Y04qwjapglptKOzjIJjKKgXuPqrG7v\\/h1\\/vavIxCMIkYoahxWZulxX6EPqqyu7fH7t6ecb9gCMD3\\/X4UQHgikwGrBi5HyjgIccZlibHtt6bZb9l97ck4AnzfH\\/pbB0F3yQxqNb74+CwwqBswCkEHTiV5xhfy3RDEy\\/bU2GOFxn77qlQq9TzPC\\/9ue+fDE8ranx5mKfJTJRWkuPZCJuHtP3\\/Og4cPjb9VZtRQhiAAwGQg2OS07\\/sEQUC1WjUGYL0OOB0caPctdI\\/7VwvNFWOcZCg2Bc33\\/ZEUNZV1BAjFRQIQFqOFfJfyxYvKfoei4B9oqr7iJBu3nX2w+LZ4FMIr8gDMefPaQcsQdFJV7XEQdLM9UQAwgACwXPSihwyZG2cqCiLaflyIu5gHy\\/cFdFEAcJZWuF0sFsPtJBDi6k1UEwEA5hCEBIz91rRRfgsI9aCm7VMoCIJw28U8OL4xUr50qfeu0wHA87yxEEC\\/foDR8Jb7U\\/UpGwd385DglZlSqTT0z4f33iDsdRCEsbhZjbaV+4war9frnMrleP3mzeQAfHblSmj84OVLZmdnAQhyZ0baflrIj3xmAkEYVfXpHb8DBuYBzp87x4PHj7NNAdk4wMGLF\\/2NqSlnCG8b9dBQnOR+3zYC8p1WaB76AIRsQRg11poXmurffKhA6AyKNiYAAP5stkaMC8kAwA5COq\\/MHB0Bgycx3uzAoM6od\\/yOIHeGIHdGC6Fer4fbH+ZyEDEfNe6i5CmgUOf4GIDWqUH45zujOS\\/2q\\/bJ0oW7SpmkgKwoCKE4IGlIZdy18MlK5W0sHZSslIbxE52or78B1axIfFSYA8gAAAAASUVORK5CYII="
    
    @State var stringImage = "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"
    
    @State var stringImage2 = ""
    
    
    
    
    var body: some View {
        ZStack{
            InViewDarkGray
                .ignoresSafeArea()
            VStack{
                Text("Sample: \(temporaryName)")
                    .foregroundColor(.white)
                
                //While I am fetching the shit from the database and the string is still empty I present the progress bar
                if(stringImage2 == ""){
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                }else{
                    Image(uiImage: UIImage(data: Data(base64Encoded: stringImage2)!)!)
                        .padding()
                }
                
                

            }
            
        }
        .onAppear{
            homeModel.getItems()
            homeModel.delegate = self

        }
        .preferredColorScheme(.dark)
    }
    
    
    
    func itemsDownloaded(movies: [Movie]) {
       temporaryName = movies[0].Title
    }
    
}

struct DatabaseTestView_Previews: PreviewProvider {
    static var previews: some View {
        DatabaseTestView()
    }
    
}
