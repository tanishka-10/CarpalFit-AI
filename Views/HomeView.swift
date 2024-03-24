import SwiftUI

struct HomeView: View {
    @EnvironmentObject var applicationModel: ApplicationModel
    @State private var animateGradient = true
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                VStack() {
                    VStack() {
                        VStack() {
                            Text("App Name")
                                .font(.largeTitle).foregroundColor(Color.white)
                                .padding([.top, .bottom], 40)
                            Image("Rock")
                                .resizable()
                                .frame(width: 250, height: 250)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                                .padding(.bottom, 50)
                        }
                        VStack() {
                            NavigationLink(destination: NavigationsView()) {
                                Text("Start").font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 300, height: 50)
                                    .background(Color.green)
                                    .cornerRadius(15.0)
                            } .padding([.top], 40)
                            NavigationLink(destination: NavigationsView()) {
                                Text("Learn More").font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 300, height: 50)
                                    .background(Color.teal)
                                    .cornerRadius(15.0)
                            } .padding([.top], 40)
                            Text("This is a short description of the app ")
                                .font(.title).foregroundColor(Color.white)
                                .padding([.all], 40)
                                .multilineTextAlignment(.center)
                        }
                    }.frame(height: geo.size.height * (1))
                    Divider()
                }.background(
                    //LinearGradient(colors: [Color( red: 20/255, green: 78/255, blue: 118/255), .cyan.opacity(0.7)], startPoint: animateGradient ? .topLeading : //.bottomLeading, endPoint: animateGradient ? .bottomTrailing : .topTrailing)
                    LinearGradient(colors: [.indigo.opacity(0.7), .blue.opacity(0.7)], startPoint: animateGradient ? .topLeading : .bottomLeading, endPoint: animateGradient ? .bottomTrailing : .topTrailing)
                        .ignoresSafeArea()
                        .onAppear {
                            withAnimation(.linear(duration: 1.5)) {
                                animateGradient.toggle()
                            }
                        }
                )
            }.environmentObject(applicationModel)
                .onAppear {
                    applicationModel.resetSelection()
                }
        }.navigationViewStyle(.stack)
    }
}



