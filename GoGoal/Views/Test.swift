//
//  Test.swift
//  GoGoal
//
//  Created by Sihan Chen on 11/15/21.
//

import SwiftUI

struct Test: View {
    var body: some View {
      
      NavigationView{
      ScrollView(.vertical, content: {
        VStack{
          ForEach(0..<10) { index in
            Rectangle()
              .fill(Color.yellow)
              .frame(height: 300)
            
          }
        }
      })
        
      
      }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
