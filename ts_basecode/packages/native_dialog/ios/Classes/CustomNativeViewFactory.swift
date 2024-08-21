//
//  CustomNativeViewFactory.swift
//  native_dialog
//
//  Created by Trần Hải Ninh on 21/8/24.
//

import Flutter
import UIKit

class CustomNativeViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return FLNativeView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger)
    }

    /// Implementing this method is only necessary when the `arguments` in `createWithFrame` is not `nil`.
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class FLNativeView: NSObject, FlutterPlatformView {
    private var _view: UIView

    private var channel: FlutterMethodChannel?

    private var messenger: FlutterBinaryMessenger?

    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?
    ) {
        _view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        self.messenger = messenger
        super.init()
        // iOS views can be created here
        createNativeView(view: _view, arguments: args, viewId: viewId)
    }

    func view() -> UIView {
        return _view
    }

    func createNativeView(view _view: UIView, arguments args: Any?, viewId: Int64){
        let imageView = UIImageView()

        // Configure imageView
        imageView.image = UIImage(named: "Achievement") // Replace "exampleImage" with your image name
        imageView.contentMode = .scaleAspectFit
        imageView.sizeToFit()
        _view.addSubview(imageView)

        _view.backgroundColor = UIColor.clear
        let titleLabel = UILabel()
        titleLabel.text = "Congratulation"
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center

        let descriptionLabel = UILabel()
        descriptionLabel.textColor = UIColor.black
        descriptionLabel.textAlignment = .center

        if let dict = args as? [String: Any], let distance = dict["distance"] as? String {
            descriptionLabel.text = "You have run total \(distance)m."
        }

        let button = UIButton(type: .system)
        button.setTitle("Close", for: .normal)
        button.frame = CGRect(x: 0, y: _view.bounds.height / 2, width: _view.bounds.width, height: _view.bounds.height / 2)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        _view.addSubview(button)

        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.frame = CGRect(x: 0, y: 0, width: _view.frame.width, height: _view.frame.height)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(button)
        _view.addSubview(stackView)

        channel = FlutterMethodChannel(name: "native_dialog_\(viewId)", binaryMessenger: messenger!)
    }

    @objc private func buttonTapped() {
           // Notify Flutter that the button was tapped
           channel?.invokeMethod("buttonTapped", arguments: nil)
       }
}
