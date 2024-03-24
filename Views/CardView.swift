import SwiftUI

struct CardView : View {
    @EnvironmentObject var applicationModel: ApplicationModel
    @State var cardModel: CardModel
    
    init(cardModel: CardModel) {
        self.cardModel = cardModel
    }
    var body: some View {
        VStack(alignment: .center, spacing: 16, content: {
            Image(cardModel.getImageId())
                .resizable()
                .frame(width: 200, height:200)
            VStack(alignment: .center, content: {
                Text(cardModel.getImageName()).font(.headline)
            }).padding(.horizontal, 8).padding(.bottom, 16)
                .foregroundColor(cardModel.isSelected ? Color.white : Color.black)

        })
        .background(cardModel.getIsSelected() ? Color.teal : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/))
        .shadow(radius: 9)
        .onTapGesture {
            cardModel.toggleIsSelected()
            applicationModel.selectExcercise(excerciseId: cardModel.getImageId())
        }
    }
}
