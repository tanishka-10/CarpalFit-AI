import SwiftUI

struct SelectionView: View {
    @EnvironmentObject var applicationModel: ApplicationModel
    @State var showingAlert = true
    private let numberColumns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    private let adaptiveColumns = [
        GridItem(.adaptive(minimum: 200))
    ]
    
   private let fixedColumns = [
        GridItem(.fixed(200)),
        GridItem(.fixed(200))
    ]
    
    var body: some View {
       
            VStack{
                VStack {
                    ScrollView {
                        LazyVGrid(columns: adaptiveColumns, spacing: 30) {
                            ForEach(applicationModel.cards) { card in
                                ZStack {
                                    CardView(cardModel: card)
                                }
                            }
                        }
                    }
                    .navigationTitle("Select Excercise")
                }.onAppear {
                    applicationModel.resetSelection()
                }
                VStack {
//                    Button("Select All") {
//                        applicationModel.selectAllExcercise()
//                    } .font(.headline)
//                      .foregroundColor(.white)
//                       .padding()
//                       .frame(width: 300, height: 50)
//                       .background(Color(red: 20/255, green: 78/255, blue: 118/255))
//                       .cornerRadius(15.0).padding([.top], 10)
//                    Button("De-Select All") {
//                        applicationModel.deSelectAllExcercise()
//                    } .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(width: 300, height: 50)
//                        .background(Color(red: 20/255, green: 78/255, blue: 118/255))
//                        .cornerRadius(15.0).padding([.top], 10)
                    if(applicationModel.selectedExcercise.count > 0) {
                        NavigationLink(destination: StepView()) {
                            Text("Start").font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(Color(red: 20/255, green: 78/255, blue: 118/255))
                                .cornerRadius(15.0)
                                
                        } .padding([.bottom], 50)
                        .padding([.top], 20)
                    } else {
                        Text("Start").font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 300, height: 50)
                                .background(.gray)
                                .cornerRadius(15.0)
                                .padding([.bottom], 50)
                                .padding([.top], 20)
                    }
                   
                } 
            
        }.environmentObject(applicationModel)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity
            ).background(
                LinearGradient(colors: [.indigo.opacity(0.7), .blue.opacity(0.7)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea())
            .onAppear{applicationModel.resetSelection() }
    }
}


//struct SelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectionView()
//            .environmentObject(ApplicationModel())
//    }
//}
