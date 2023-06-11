//
//  DeliveryChoiceStepsView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 11.06.2023.
//

import SwiftUI

struct DeliveryChoiceStepsView: View {
    private let steps: [EDeliveryChoiceSteps] = EDeliveryChoiceSteps.allCases
    @State var selectedStep : EDeliveryChoiceSteps = .pickup
    @State var stepsDone: [EDeliveryChoiceSteps] = [.pickup]
    
    func getStepIsDone(step: EDeliveryChoiceSteps) -> Bool{
        return stepsDone.contains(step)
    }
    var body: some View {
        ZStack{
            HStack(spacing:4){
                ForEach(steps, id: \.self){ step in
                    VStack{
                        Image(systemName: step.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .padding(.top)
                            .padding(.horizontal)
                            .scaleEffect(x: step.angle)
                        Text(step.title)
                            .font(.caption)
                            .padding(.horizontal)
                            .padding(.bottom)
                            .bold()
                    }
                    .foregroundStyle(.white)
                    .background(selectedStep == step ? RadialGradient.gradientNextSteps : getStepIsDone(step: step) ? RadialGradient.gradientDoneSteps : RadialGradient.gradientWaitedSteps)
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 14, height: 14)))
                    .scaleEffect(selectedStep == step ? 1.2 : 0.8)
                    .offset(y: selectedStep == step ? 0 : 14)
                    .onTapGesture {
                        withAnimation(.spring()){selectedStep = step}
                    }
                }
            }
            
        }
        
        
    }
    
    
}

#Preview {
    DeliveryChoiceStepsView()
}
