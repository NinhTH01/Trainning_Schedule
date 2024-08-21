package com.example.native_dialog

import android.content.Context
import android.graphics.Color
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class CustomNativeView(context: Context, id: Int, creationParams: Map<String?, Any?>?, private val methodChannel: MethodChannel) : PlatformView {
    private val layout: LinearLayout = LinearLayout(context)
    private val descriptionView: TextView = TextView(context)
    private val titleView: TextView = TextView(context)
    private val button: Button = Button(context)
    private val imageView: ImageView = ImageView(context)

    override fun getView(): View {
        return layout
    }

    override fun dispose() {}

    init {
        layout.orientation = LinearLayout.VERTICAL
        layout.gravity = Gravity.CENTER

        titleView.text = "Congratulation"
        titleView.textSize = 20f
        titleView.gravity = Gravity.CENTER
        titleView.setTypeface(null, android.graphics.Typeface.BOLD)
        layout.addView(titleView)

        imageView.setImageResource(R.drawable.medal) // Replace with your image resource name
        imageView.scaleType = ImageView.ScaleType.FIT_CENTER
        imageView.layoutParams = ViewGroup.LayoutParams(400, 400)
        layout.addView(imageView)

        val distance = creationParams?.get("distance") as String? ?: "0.0"
        descriptionView.text = "You have run total ${distance} m."
        descriptionView.textSize = 16f
        descriptionView.gravity = Gravity.CENTER
        descriptionView.setPadding(descriptionView.paddingLeft, 20, descriptionView.paddingRight, descriptionView.paddingBottom)
        layout.addView(descriptionView)

        button.text = "Close"
        button.background = context.getDrawable(R.drawable.outlined_button)
        button.setTextColor(Color.BLUE)
        button.setOnClickListener {
            methodChannel.invokeMethod("buttonTapped", null)
        }
        layout.addView(button)
    }
}