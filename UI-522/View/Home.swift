//
//  Home.swift
//  UI-522
//
//  Created by nyannyan0328 on 2022/03/28.
//

import SwiftUI

struct Home: View {
    @State var progress : CGFloat = 0
    @State var charcters : [Character] = characters_
    @State var shuffledRowas : [[Character]] = []
    @State var rows : [[Character]] = []
    
    
    @State var animatedWrogtext : Bool = false
    
    @State var dropCount : CGFloat = 0
   
    var body: some View {
        VStack(spacing:15){
            TopBar()
            
            
            VStack(alignment: .leading, spacing: 13) {
                
                Text("Frome This Sentence")
                    .font(.title.weight(.ultraLight))
                
                Image("Character")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.trailing,100)
                
            }
            .padding(.top,30)
            
            DropArea()
                .padding(.vertical,30)
            
            DragArea()
            
        }
        .padding()
        .onAppear {
            
            
            if rows.isEmpty{
                
                charcters = charcters.shuffled()
                shuffledRowas = generatedGrid()
                charcters = characters_
                rows = generatedGrid()
            }
            
        }
        .offset(x: animatedWrogtext ? -20 : 0)
    }
    @ViewBuilder
    func TopBar()->some View{
        
        HStack{
            
            
            Button {
                
            } label: {
                
                Image(systemName: "xmark")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.gray)
            }
            
            GeometryReader{proxy in
                
                
                ZStack(alignment: .leading) {
                    
                    
                    Capsule()
                        .fill(.gray.opacity(0.3))
                    
                    Capsule()
                        .fill(Color("Green"))
                        .frame(width: proxy.size.width * progress)
                    
                }
                
                
            }
            .frame(height:30)
            
            
            Button {
                
            } label: {
                
                Image(systemName: "suit.heart.fill")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.gray)
            }

            
        }
    }
    
    func generatedGrid()->[[Character]]{
        
        for item in charcters.enumerated(){
            
            
            let textSize = textSize(character: item.element)
            
            charcters[item.offset].textSize = textSize
            
            
        }
        
        
        var gridArray : [[Character]] = []
        
        var temArray : [Character] = []
        
        var currentWidth : CGFloat = 0
        
        let totalScreenWidth = UIScreen.main.bounds.width - 30
        
        for charcter in charcters {
            
            currentWidth += charcter.textSize
            
            if currentWidth < totalScreenWidth{
                
                
                
                temArray.append(charcter)
            }
            else{
                
                
                gridArray.append(temArray)
                temArray = []
                currentWidth = charcter.textSize
                temArray.append(charcter)
            }
            
          
        }
        if !temArray.isEmpty{
            
            gridArray.append(temArray)
            
        }
        
        return gridArray
        
        
    }
    
    func textSize(character : Character) -> CGFloat{
        
        let font = UIFont.systemFont(ofSize: character.fontSize)
        
        let attributes = [NSAttributedString.Key.font:font]
        
        let size = (character.value as NSString).size(withAttributes: attributes)
        
        return size.width + (character.padding * 2) + 15
    }
    
    @ViewBuilder
    func DropArea()->some View{
        
        
        VStack(spacing:15){
            
            ForEach($rows,id:\.self){$row in
                
                HStack(spacing:10){
                    
                    ForEach($row){$item in
                        
                        
                        Text(item.value)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical,5)
                            .padding(.horizontal,item.padding)
                            .opacity(item.isShowing ? 1 : 0)
                            .background(
                            
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(item.isShowing ? .clear : .gray.opacity(0.25))
                            
                            
                            )
                            
                          
                            .background(
                            
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(.gray)
                                    .opacity(item.isShowing ? 1 : 0)
                            
                            
                            )
                            .onDrop(of: [.url], isTargeted: .constant(false)) { providers in
                                
                                
                                if let first = providers.first{
                                    
                                    let _ = first.loadObject(ofClass: URL.self) { value, err in
                                        
                                        
                                        guard let url = value else{return}
                                        
                                        
                                        if item.id == "\(url)"{
                                            
                                            dropCount += 1
                                            
                                            let progress = (dropCount / CGFloat(charcters.count))
                                            
                                            withAnimation {
                                                
                                                item.isShowing = true
                                                
                                                updateShuffledAray(character: item)
                                                
                                                self.progress = progress
                                            }
                                            
                                        }
                                        else{
                                            
                                            
                                            animtedText()
                                        }
                                    }
                                    
                                }
                                
                                return false
                            }
                        
                     
                            
                        
                    }
                    
                    
                    
                }
                
                if rows.last != row{
                    
                    Divider()
                }
        
        
        
        
    }
            
        }
    }
    @ViewBuilder
    func DragArea()->some View{
        
        
        VStack(spacing:15){
            
            ForEach(shuffledRowas,id:\.self){row in
                
                HStack(spacing:10){
                    
                    ForEach(row){item in
                        
                        
                        Text(item.value)
                            .font(.system(size: item.fontSize))
                            .padding(.vertical,5)
                            .padding(.horizontal,item.padding)
                            .background(
                            
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(.gray)
                            
                            
                            )
                            .onDrag {
                                
                                return .init(contentsOf: URL(string: item.id))!
                                
                            }
                           // .opacity(item.isShowing ? 0 : 1)
                            .background(
                            
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(item.isShowing ? .gray.opacity(0.25) : .clear)
                            
                            
                            )
                        
                    }
                    
                    
                    
                }
                
                if shuffledRowas.last != row{
                    
                    Divider()
                }
                
            }
        }
        
        
    }
    
    
    
    func animtedText(){
        
        withAnimation(.interactiveSpring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)){
            
            
            
            animatedWrogtext = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            
            withAnimation(.interactiveSpring(response: 0.2, dampingFraction: 0.2, blendDuration: 0.2)){
                
                
                
                animatedWrogtext = false
            }
            
            
        }
    }
    
    func updateShuffledAray(character : Character){
        
        for index in shuffledRowas.indices{
            
            
            for subIndex in shuffledRowas[index].indices{
                
                
                if shuffledRowas[index][subIndex].id == character.id{
                    shuffledRowas[index][subIndex].isShowing = true
                    
                    
                }
            }
        }
        
        
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
