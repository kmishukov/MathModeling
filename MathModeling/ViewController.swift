//
//  ViewController.swift
//  Task1
//
//  Created by Konstantin Mishukov on 31.03.2020.
//  Copyright © 2020 Konstantin Mishukov. All rights reserved.
//

import Cocoa
import CorePlot

class ViewController: NSViewController, NSTextFieldDelegate {
    
    private var scatterGraph : CPTXYGraph? = nil
    private var newGraph: CPTXYGraph!
    private var plotSpace: CPTXYPlotSpace!
    private var graphScale: Float = 100.0;
    
    typealias plotDataType = [CPTScatterPlotField : Double]
    private var dataForPlot = [plotDataType]()
    
    @IBOutlet weak var buildButton: NSButton!
    @IBOutlet weak var massTextField: NSTextField!
    @IBOutlet weak var forceTextField: NSTextField!
    @IBOutlet weak var hostView: CPTGraphHostingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 800, height: 800)
        
        // Create graph from theme
        newGraph = CPTXYGraph(frame: .zero)
        newGraph.apply(CPTTheme(named: .darkGradientTheme))
        
        hostView.hostedGraph = newGraph
        hostView.allowPinchScaling = true
        
        // Paddings
        newGraph.paddingLeft   = 10.0
        newGraph.paddingRight  = 10.0
        newGraph.paddingTop    = 10.0
        newGraph.paddingBottom = 10.0
        
        // Plot space
        plotSpace = newGraph.defaultPlotSpace as? CPTXYPlotSpace
        plotSpace.allowsUserInteraction = true
        plotSpace.yRange = CPTPlotRange(location:-8.0, length:NSNumber(value: graphScale))
        plotSpace.xRange = CPTPlotRange(location:-8.0, length:NSNumber(value: graphScale))
        
        // Axes
        let axisSet = newGraph.axisSet as! CPTXYAxisSet
        
        if let x = axisSet.xAxis {
            x.majorIntervalLength   = 10
            x.minorTicksPerInterval = 1
            x.orthogonalPosition    = 0.0
        }
        
        if let y = axisSet.yAxis {
            y.majorIntervalLength   = 10
            y.minorTicksPerInterval = 1
            y.orthogonalPosition    = 0.0
            y.delegate = self
        }
        
        // Create a blue plot area
        let boundLinePlot = CPTScatterPlot(frame: .zero)
        let blueLineStyle = CPTMutableLineStyle()
        blueLineStyle.miterLimit    = 1.0
        blueLineStyle.lineWidth     = 2.0
        blueLineStyle.lineColor     = .blue()
        boundLinePlot.dataLineStyle = blueLineStyle
        boundLinePlot.identifier    = "Blue Plot" as NSString
        boundLinePlot.dataSource    = self
        newGraph.add(boundLinePlot)
        
        let fillImage = CPTImage(named:"BlueTexture")
        fillImage.isTiled = true
        boundLinePlot.areaFill      = CPTFill(image: fillImage)
        boundLinePlot.areaBaseValue = 0.0
        
        // Add plot symbols
        let symbolLineStyle = CPTMutableLineStyle()
        symbolLineStyle.lineColor = .black()
        let plotSymbol = CPTPlotSymbol.ellipse()
        plotSymbol.fill          = CPTFill(color: .blue())
        plotSymbol.lineStyle     = symbolLineStyle
        plotSymbol.size          = CGSize(width: 5.0, height: 5.0)
        boundLinePlot.plotSymbol = plotSymbol
        
        self.scatterGraph = newGraph
    }
    @IBAction func zoomOutPushed(_ sender: Any) {
        zoomOut()
    }
    
    @IBAction func zoomInPushed(_ sender: Any) {
        zoomIn()
    }
    
    func zoomOut() {
        graphScale += 20
        plotSpace.xRange = CPTPlotRange(location:-8.0, length:NSNumber(value: graphScale))
        plotSpace.yRange = CPTPlotRange(location:-8.0, length:NSNumber(value: graphScale))
    }
    
    func zoomIn() {
        graphScale -= 20
        plotSpace.xRange = CPTPlotRange(location:-8.0, length:NSNumber(value: graphScale))
        plotSpace.yRange = CPTPlotRange(location:-8.0, length:NSNumber(value: graphScale))
    }
    
    @IBAction func buildButtonPushed(_ sender: Any) {
        massTextField.window?.makeFirstResponder(nil)
        forceTextField.window?.makeFirstResponder(nil)
        
        guard let mass = Double(massTextField.stringValue) else {return}
        guard let force = Double(forceTextField.stringValue) else {return}
        
        var contentArray = [plotDataType]()
        for i in 0 ..< 100 {
            let x = Double(i)
            let y = pow(x, mass)
            let dataPoint: plotDataType = [.X: x, .Y: y]
            contentArray.append(dataPoint)
        }
        self.dataForPlot = contentArray
        self.scatterGraph?.reloadData()
    }
}

extension ViewController: CPTScatterPlotDelegate, CPTScatterPlotDataSource, CPTAxisDelegate {
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(self.dataForPlot.count)
    }
    
    func number(for plot: CPTPlot, field: UInt, record: UInt) -> Any? {
        let plotField = CPTScatterPlotField(rawValue: Int(field))
        if let num = self.dataForPlot[Int(record)][plotField!] {
            return num as NSNumber
        }
        else {
            return nil
        }
    }
    
    // MARK: - Axis Delegate Methods
    func axis(_ axis: CPTAxis, shouldUpdateAxisLabelsAtLocations locations: Set<NSNumber>) -> Bool
    {
        if let formatter = axis.labelFormatter {
            let labelOffset = axis.labelOffset
            
            var newLabels = Set<CPTAxisLabel>()
            
            for tickLocation in locations {
                if let labelTextStyle = axis.labelTextStyle?.mutableCopy() as? CPTMutableTextStyle {
                    if tickLocation.doubleValue >= 0.0 {
                        labelTextStyle.color = .green()
                    }
                    else {
                        labelTextStyle.color = .red()
                    }
                    
                    let labelString   = formatter.string(for:tickLocation)
                    let newLabelLayer = CPTTextLayer(text: labelString, style: labelTextStyle)
                    
                    let newLabel = CPTAxisLabel(contentLayer: newLabelLayer)
                    newLabel.tickLocation = tickLocation
                    newLabel.offset       = labelOffset
                    
                    newLabels.insert(newLabel)
                }
                
                axis.axisLabels = newLabels
            }
        }
        return false
    }
}

