//
//  TopicGrid.swift
//  GoGoal
//
//  Created by sj on 11/21/21.
//

import SwiftUI

struct TopicGrid: View {
  let data : [Topic]
  let columns = [
    GridItem(.adaptive(minimum:80))
  ]
  var body: some View {
    ScrollView{
      LazyVGrid(columns:columns,spacing:20){
        ForEach(data){item in
          VStack{
            item.icon?
              .resizable()
              .clipShape(Circle())
              .shadow(radius:5)
              .overlay(Circle()
                        .stroke(Color.black,lineWidth:2))
              .frame(width:30,height:30)
            
            Text(item.name)
              .font(.system(size:10))
          }
        }
      }
    }
  }
}

