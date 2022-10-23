//
//  HapticManager.swift
//  Abuse Helper
//
//  Created by Alex Hynds on 10/22/22.
//  Copyright © 2021-2022 Hynds Productions. All rights reserved.
//

import CoreHaptics
import UIKit

let hapticManager = HapticManager()

class HapticManager {
    
    private var engine: CHHapticEngine?
    private var notif = UINotificationFeedbackGenerator()
    private var impact = UIImpactFeedbackGenerator()
    private var player: CHHapticPatternPlayer? = nil
    
    init() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("Device does not support haptic feedback")
            return
        }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Could not create Haptic Engine! Error: \(error.localizedDescription)")
        }
    }
    
    //Similar to whoosh, but the intensity follows a slightly more exponential curve, with the rate of increasing intensity increasing as it goes along
    func whooshExponential(_ firstDuration: Double = 0.5, _ secondDuration: Double = 0.5, _ sharpness: Float = 0.5, _ intensity: Float = 1) {

        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 0)
        let middle1 = CHHapticParameterCurve.ControlPoint(relativeTime: firstDuration/2, value: intensity/4)
        let middle2 = CHHapticParameterCurve.ControlPoint(relativeTime: firstDuration, value: intensity)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: firstDuration+secondDuration, value: 0)

        
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        
        // use that curve to control the haptic strength
        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, middle1,middle2, end], relativeTime: 0)

        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: firstDuration+secondDuration)

        do {
            let pattern = try CHHapticPattern(events: [event], parameterCurves: [parameter])

            player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Unable to play haptic feedback.")
        }
        
    }
    
    func whoosh(_ firstDuration: Double = 0.5, _ secondDuration: Double = 0.5, sharpness: Float) {
        
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 0)
        let middle = CHHapticParameterCurve.ControlPoint(relativeTime: firstDuration, value: 1)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: firstDuration+secondDuration, value: 0)

        // use that curve to control the haptic strength
        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, middle, end], relativeTime: 0)

        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: firstDuration+secondDuration)

        do {
            let pattern = try CHHapticPattern(events: [event], parameterCurves: [parameter])

            player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Unable to play haptic feedback.")
        }
        
    }
    
    func whoosh(_ firstDuration: Double = 0.5, _ secondDuration: Double = 0.5) {
        
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.0)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 0)
        let middle = CHHapticParameterCurve.ControlPoint(relativeTime: firstDuration, value: 1)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: firstDuration+secondDuration, value: 0)

        // use that curve to control the haptic strength
        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, middle, end], relativeTime: 0)

        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: firstDuration+secondDuration)

        do {
            let pattern = try CHHapticPattern(events: [event], parameterCurves: [parameter])

            player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Unable to play haptic feedback.")
        }
        
    }
    
    func whoosh(_ firstDuration: Double = 0.5, _ secondDuration: Double = 0.5, sharpness: Float, intensity: Float) {
        
        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 0)
        let middle = CHHapticParameterCurve.ControlPoint(relativeTime: firstDuration, value: intensity)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: firstDuration+secondDuration, value: 0)
        
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

        // use that curve to control the haptic strength
        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, middle, end], relativeTime: 0)

        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: firstDuration+secondDuration)

        do {
            let pattern = try CHHapticPattern(events: [event], parameterCurves: [parameter])

            player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Unable to play haptic feedback.")
        }
        
    }
    
    func whoosh(_ firstDuration: Double = 0.5, _ secondDuration: Double = 0.5, intensity: Float) {

        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 0)
        let middle = CHHapticParameterCurve.ControlPoint(relativeTime: firstDuration, value: intensity)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: firstDuration+secondDuration, value: 0)
        
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

        // use that curve to control the haptic strength
        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, middle, end], relativeTime: 0)

        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: firstDuration+secondDuration)

        do {
            let pattern = try CHHapticPattern(events: [event], parameterCurves: [parameter])

            player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Unable to play haptic feedback.")
        }
        
    }
    
    func whooshWithImpact(_ firstDuration: Double = 0.35, _ impactDuration: Double = 0.2) {
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 0)
        let middle = CHHapticParameterCurve.ControlPoint(relativeTime: firstDuration, value: 1)

        // use that curve to control the haptic strength
        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, middle], relativeTime: 0)

        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: firstDuration)
        
        let event2 = CHHapticEvent(eventType: .hapticContinuous, parameters: [CHHapticEventParameter(parameterID: .hapticSharpness, value: 1),CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.5)], relativeTime: firstDuration, duration: impactDuration)

        do {
            let pattern = try CHHapticPattern(events: [event,event2], parameterCurves: [parameter])

            player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Unable to play haptic feedback.")
        }
        
        notif.prepare()
        
        delay(firstDuration+impactDuration+0.2, completion: {
            self.notif.notificationOccurred(.success)
        })
        
    }
    
    ///Creates an exploding sensation divided into two unequal sections.
    ///Section 1 (1/4 duration): Consistent sharp haptic
    ///Section 2 (3/4 duration): falloff and random pops
    func explode(duration: Double = 2.5) {
        
        let firstDuration = duration/7
        let secondDuration = 6*(duration/7)
        
        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0.0, value: 0.0)
        let mid1 = CHHapticParameterCurve.ControlPoint(relativeTime: firstDuration/3, value: 1.0)
        let mid2 = CHHapticParameterCurve.ControlPoint(relativeTime: duration/3, value: 1.0)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: duration, value: 0)
        
        var events: [CHHapticEvent] = []
        
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.0)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        
        //Fading out
        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start,mid1,mid2, end], relativeTime: 0)
        
        events.append(CHHapticEvent(eventType: .hapticContinuous, parameters: [CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0), intensity], relativeTime: 0.0, duration: firstDuration))
        
        events.append(CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: firstDuration, duration: secondDuration))
        
        //Pops
        for _ in 1...Int(duration*10) {
            events.append(CHHapticEvent(eventType: .hapticTransient, parameters: [CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0),CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)], relativeTime: (duration/3)+TimeInterval.random(in: 0.0...2*(duration/3))))
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameterCurves: [parameter])

            player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Unable to play haptic feedback.")
        }
    }
    
    ///Creates an increasing sensation with a "success" at the end
    func regenerate(_ duration: Double = 1.0, successAtEnd: Bool = true) {
        if(successAtEnd) { prepare() }
        
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.25)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 0)
        let mid = CHHapticParameterCurve.ControlPoint(relativeTime: duration*0.8, value: 1)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: duration, value: 0)

        // use that curve to control the haptic strength
        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, mid, end], relativeTime: 0)

        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: duration)

        do {
            let pattern = try CHHapticPattern(events: [event], parameterCurves: [parameter])

            player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Unable to play haptic feedback.")
        }
        
        delay(duration+0.2, completion: {
            self.success()
        })
    }
    
    /// Increases haptic sensation to a point and then clicks
    func popUp(_ duration: Double) {
        prepare()
        
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.5)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 0)
        let mid = CHHapticParameterCurve.ControlPoint(relativeTime: duration*0.8, value: 0.5)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: duration, value: 0)

        // use that curve to control the haptic strength
        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, mid, end], relativeTime: 0)

        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: duration)

        do {
            let pattern = try CHHapticPattern(events: [event], parameterCurves: [parameter])

            player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Unable to play haptic feedback.")
        }
        
        delay(duration+0.1, completion: {
            self.click(0.5)
        })
        
    }
    
    func grow(duration: Double, intensity: Float, sharpness: Float = 1.0) {

        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 0)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: duration, value: intensity)

        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        
        // use that curve to control the haptic strength
        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, end], relativeTime: 0)

        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: duration)

        do {
            let pattern = try CHHapticPattern(events: [event], parameterCurves: [parameter])

            player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Unable to play haptic feedback.")
        }
    }
    
    func shrink(duration: Double, intensity: Float, sharpness: Float = 1.0) {

        let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: intensity)
        let end = CHHapticParameterCurve.ControlPoint(relativeTime: duration, value: 0)

        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        
        // use that curve to control the haptic strength
        let parameter = CHHapticParameterCurve(parameterID: .hapticIntensityControl, controlPoints: [start, end], relativeTime: 0)

        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [sharpness, intensity], relativeTime: 0, duration: duration)

        do {
            let pattern = try CHHapticPattern(events: [event], parameterCurves: [parameter])

            player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Unable to play haptic feedback.")
        }
    }
    
    func prepare() {
        notif.prepare()
        impact.prepare()
    }
    
    func success() {
        notif.notificationOccurred(.success)
    }
    
    func error() {
        notif.notificationOccurred(.error)
    }
    
    func warning() {
        notif.notificationOccurred(.warning)
    }
    
    func click() {
        impact.impactOccurred()
    }
    
    func click(_ intensity: Double) {
        impact.impactOccurred(intensity: intensity)
    }
    
    
    func delay(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    ///Stops all haptic feedback
    func cancel() {
        do {
            try player?.cancel()
        } catch {
            print("Could not stop the Haptic player!")
        }
    }
    
}
