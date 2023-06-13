//
//  DeliveryChoiceStepsView.swift
//  PackageDeliverySwiftUI
//
//  Created by Baris OZGEN on 11.06.2023.
//

import SwiftUI

struct DeliveryChoiceStepsView: View {
    private let steps: [EDeliveryChoiceSteps] = EDeliveryChoiceSteps.allCases
    @Binding var selectedStep : EDeliveryChoiceSteps
    @Binding var stepsDone: [EDeliveryChoiceSteps]
    @Binding var searchText: String
    @State private var deliveryChoiceStepsViewY: Double = 129
    @State private var deliveryChoiceStepsViewX: Double = -129
    @Binding var isDeliveryStepsStarted: Bool

    func getStepIsDone(step: EDeliveryChoiceSteps) -> Bool{
        return stepsDone.contains(step)
    }
    func canDropOffLocationSearch() -> Bool {
        return selectedStep == .dropoff && stepsDone.contains(.package) && !stepsDone.contains(.dropoff)
    }
    var body: some View {
        ZStack{
            // horizantal menu
            if !isDeliveryStepsStarted{
                VStack{
                    Spacer()
                    ZStack {
                        HStack(spacing:0){
                            ForEach(steps, id: \.self){ step in
                                HStack(spacing:0){
                                    VStack{
                                        Image(systemName: step.image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 32, height: 32)
                                            .padding(.top)
                                            .padding(.horizontal)
                                            .scaleEffect(x: step.scale)
                                        Text(step.title)
                                            .font(.caption)
                                            .padding(.horizontal)
                                            .padding(.bottom)
                                            .bold()
                                    }
                                    .foregroundStyle(.white)
                                    .background(selectedStep == step || getStepIsDone(step: step) ? RadialGradient.gradientDoneSteps : RadialGradient.gradientWaitedSteps)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 14, height: 14)))
                                    .shadow(color: .primary.opacity(0.7), radius: 2, x: 0, y: 2)
                                    .scaleEffect(selectedStep == step ? 1.2 : 0.8)
                                    .offset(y: selectedStep == step ? 0 : 14)
                                    .onTapGesture {
                                        withAnimation(.spring()){selectedStep = step}
                                    }
                                    if (step != .request){
                                        Image(systemName: "arrow.right")
                                            .bold()
                                            .frame(width: 14, height: 4)
                                            .foregroundStyle( getStepIsDone(step: step) ? RadialGradient.gradientDoneSteps : RadialGradient.gradientWaitedSteps)
                                            .shadow(color: .primary.opacity(0.92), radius: 1, x: 0, y: 1)
                                            .offset(y: selectedStep == step ? 0 : 14)
                                            .opacity(selectedStep == step ? 0 : 1)
                                    }
                                }
                            }
                        }
                        .offset(y: deliveryChoiceStepsViewY)
                        .onAppear{
                            withAnimation(.smooth.delay(1.29)){
                                deliveryChoiceStepsViewY = 0
                            }
                        }
                        
                    }
                    .scaleEffect(canDropOffLocationSearch() ? 0.7 : 1)
                    .offset(x: canDropOffLocationSearch() ? -70 : 0)
                    if canDropOffLocationSearch() {
                        SearchBarView(searchText: $searchText)
                    }
                }
            }
            // vertical menu
            else {
                HStack{
                    VStack {
                        Spacer()
                        ZStack {
                            VStack(spacing:0){
                                ForEach(steps, id: \.self){ step in
                                    VStack(spacing:0){
                                        VStack{
                                            Image(systemName: step.image)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 32, height: 32)
                                                .padding(.top)
                                                .padding(.horizontal)
                                                .scaleEffect(x: step.scale)
                                            Text(step.title)
                                                .font(.caption)
                                                .padding(.horizontal)
                                                .padding(.bottom)
                                                .bold()
                                        }
                                        .foregroundStyle(.white)
                                        .background(selectedStep == step || getStepIsDone(step: step) ? RadialGradient.gradientDoneSteps : RadialGradient.gradientWaitedSteps)
                                        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 14, height: 14)))
                                        .shadow(color: .primary.opacity(0.7), radius: 2, x: 0, y: 2)
                                        .scaleEffect(selectedStep == step ? 1.2 : 0.8)
                                        .offset(y: selectedStep == step ? 0 : 14)
                                        .onTapGesture {
                                            withAnimation(.spring()){selectedStep = step}
                                        }
                                        if (step != .request){
                                            Image(systemName: "arrow.down")
                                                .bold()
                                                .frame(width: 14, height: 4)
                                                .foregroundStyle( getStepIsDone(step: step) ? RadialGradient.gradientDoneSteps : RadialGradient.gradientWaitedSteps)
                                                .shadow(color: .primary.opacity(0.92), radius: 1, x: 0, y: 1)
                                                .offset(y: selectedStep == step ? 0 : 14)
                                                .opacity(selectedStep == step ? 0 : 1)
                                                .padding(.vertical, 4)
                                        }
                                    }
                                }
                            }
                            .offset(x: deliveryChoiceStepsViewX)
                            .onAppear{
                                withAnimation(.smooth.delay(1.29)){
                                    deliveryChoiceStepsViewX = 0
                                }
                            }
                        }
                        .padding(.bottom, 70)
                        .scaleEffect(0.7)
                    }
                    Spacer()
                }
            }
           
        }
    }
}

#Preview {
    DeliveryChoiceStepsView(selectedStep: .constant(.pickup), stepsDone: .constant([]), searchText: .constant(""), isDeliveryStepsStarted: .constant(true))
}
