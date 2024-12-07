//
//  CustomCorners.swift
//  Echos-of-Infinity-final
//
//  Created by James Wang on 12/4/24.
//
import SwiftUI

struct CustomCorners: Shape {
    var topLeft: CGFloat
    var topRight: CGFloat
    var bottomRight: CGFloat
    var bottomLeft: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX + topLeft, y: rect.minY))
        path.addArc(
            center: CGPoint(x: rect.minX + topLeft, y: rect.minY + topLeft),
            radius: topLeft,
            startAngle: Angle(degrees: 180),
            endAngle: Angle(degrees: 270),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.maxX - topRight, y: rect.minY))
        path.addArc(
            center: CGPoint(x: rect.maxX - topRight, y: rect.minY + topRight),
            radius: topRight,
            startAngle: Angle(degrees: 270),
            endAngle: Angle(degrees: 0),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - bottomRight))
        path.addArc(
            center: CGPoint(x: rect.maxX - bottomRight, y: rect.maxY - bottomRight),
            radius: bottomRight,
            startAngle: Angle(degrees: 0),
            endAngle: Angle(degrees: 90),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY))
        path.addArc(
            center: CGPoint(x: rect.minX + bottomLeft, y: rect.maxY - bottomLeft),
            radius: bottomLeft,
            startAngle: Angle(degrees: 90),
            endAngle: Angle(degrees: 180),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + topLeft))
        return path
    }
}
