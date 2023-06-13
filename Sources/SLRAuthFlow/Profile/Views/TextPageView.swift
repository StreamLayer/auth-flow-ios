//
//  TextPageView.swift
//  StreamLayer
//
//  Created by Kirill Kunst on 22.05.2023.
//

import Foundation
import SwiftUI

struct TextPageView: View {

  private var title: String
  private var text: String
  private var onBack: () -> Void

  init(title: String, text: String, onBack: @escaping () -> Void) {
    self.title = title
    self.text = text
    self.onBack = onBack
  }

  var body: some View {
    ScrollView(.vertical) {
      VStack {
        Text(text)
          .font(.system(size: 18.0))
          .foregroundColor(.white)
          .padding(.horizontal, 16.0)
          .padding(.top, 35)
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    .navigationTitle(title)
    .background(Color.black)
    .navigationBarTitleDisplayMode(.inline)
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        backButton
      }
    }
  }

  var backButton: some View {
    Button {
      onBack()
    } label: {
      Image("icon_chevron_left", bundle: .module)
    }
  }

}
