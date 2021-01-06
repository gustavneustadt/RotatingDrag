//
//  ContentView.swift
//  RotatingDrag
//
//  Created by Gustav on 06.01.21.
//

import SwiftUI

struct ContentView: View {
    
    // default knob angle
    @State var knobAngle = Angle(degrees: 135)
    
    // knob size
    var knobSize = CGSize(width: 200, height: 200)
    
    // limits the range of the knob
    var knobAngleLimit = [0.0, 270.0]
    
    // rotates the angle the knob outputs its value
    var knobAngleOffset = 45.0
    
    
    @GestureState var isDragging = false
    
    var volume: Double {
        return remap(knobAngle.degrees, low: 0, high: 270, toLow: 0, toHigh:1)
    }
    
    func remap(_ value: Double, low: Double, high: Double, toLow: Double, toHigh: Double) -> Double {
        
        let upper = toLow + (value - low) * (toHigh - toLow)
        let lower = (high - low)
        
        
        return upper / lower
    }
    
    func shiftLimit(_ value: Double, shift: Double, min: Double, max: Double) -> Double {
        let shiftedValue = value + shift
        if(shiftedValue > max) {
            return shiftedValue - max
        }
        if(shiftedValue < min) {
            return max - (min - shiftedValue)
        }
        return shiftedValue
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Volume: \(volume)")
                ZStack {
                    KnobView(size: knobSize)
                        .rotationEffect(
                            Angle(degrees:
                                    shiftLimit(
                                        knobAngle.degrees-180,
                                        shift: -knobAngleOffset,
                                        min:-180,
                                        max:180
                                    )
                            )
                        )
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged({ value in
                                    
                                    let deltaX = value.location.x - (knobSize.width / 2)
                                    let deltaY = value.location.y - (knobSize.height / 2)
                                    
                                    let radians = Double(atan2(deltaY, deltaX))
                                    
                                    
                                    var shiftedAngle = shiftLimit(
                                        Angle(radians:radians).degrees+180,
                                        shift: knobAngleOffset,
                                        min:0,
                                        max:360
                                    )
                                    
                                    let switchingThreshold = (knobAngleLimit[0] + (360 - knobAngleLimit[1])) / 2
                                    
                                    if shiftedAngle > knobAngleLimit[1] && shiftedAngle < knobAngleLimit[1] + switchingThreshold {
                                        shiftedAngle = knobAngleLimit[1]
                                    } else if shiftedAngle < knobAngleLimit[0] || shiftedAngle >= knobAngleLimit[1] + switchingThreshold {
                                        shiftedAngle = knobAngleLimit[0]
                                    }

                                    self.knobAngle = Angle(degrees: shiftedAngle)
                                        
                                })
                                .updating($isDragging, body: { (value, state, trans) in
                                    state = true
                                })
                            
                        )
                    Text("Leise")
                        .font(Font.system(.body).smallCaps())
                        .offset(x: -90, y: 90)
                    Text("Laut")
                        .font(Font.system(.body).smallCaps())
                        .offset(x: 90, y: 90)
                }
                Spacer()
                
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
