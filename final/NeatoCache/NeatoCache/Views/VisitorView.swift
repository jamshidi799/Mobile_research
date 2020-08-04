/// Copyright (c) 2020 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct VisitorView: View {
  @State private var visitorName = ""
  @State private var locationModel: Location?

  // swiftlint:disable multiple_closures_with_trailing_closure multiline_arguments
  private var visitorSection: some View {
    Section(header: Text("Visitor Information")) {
      TextField("Enter Your Name", text: $visitorName)
        .textContentType(.name)
        .autocapitalization(.words)

      Button(action: {
        NFCUtility.performAction(.addVisitor(visitorName: self.visitorName)) { location in
          self.locationModel = try? location.get()
          self.visitorName = ""
        }
      }) {
        Text("Add To Tag…")
      }
      .disabled(visitorName.isEmpty)
    }
  }

  private var scanSection: some View {
    Section {
      Button(action: {
        NFCUtility.performAction(.readLocation) { location in
          self.locationModel = try? location.get()
        }
      }) {
        Text("Scan Location Tag…")
      }
    }
  }
  // swiftlint:enable multiple_closures_with_trailing_closure multiline_arguments

  private var scannedSection: some View {
    locationModel.map { location in
      Section(
        header: Text("Location: \(location.name)"),
        footer: Text("Visitors: \(location.visitors.count)")) {
          ForEach(location.visitors, id: \.self) { visitor in
            Text(visitor.name)
          }
      }
    }
  }

  var body: some View {
    NavigationView {
      Form {
        visitorSection
        scanSection
        scannedSection
      }
      .navigationBarTitle("Visitors")
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct VisitorView_Previews: PreviewProvider {
  static var previews: some View {
    VisitorView()
  }
}
