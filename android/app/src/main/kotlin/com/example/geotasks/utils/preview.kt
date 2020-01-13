package com.example.geotasks.utils

import android.content.Context
import android.view.SurfaceHolder
import android.view.SurfaceView
import android.view.ViewGroup
import android.hardware.Camera
import java.io.IOException

class Preview(context: Context,  val surfaceView: SurfaceView = SurfaceView(context)
) : SurfaceView(context), SurfaceHolder.Callback {
    var mHolder: SurfaceHolder = surfaceView.holder.apply {
        addCallback(this@Preview)
        setType(SurfaceHolder.SURFACE_TYPE_PUSH_BUFFERS)
    }
    private var mCamera: Camera? = null
    private var mSupportedPreviewSizes: MutableList<Camera.Size>? = null

    override fun onLayout(p0: Boolean, p1: Int, p2: Int, p3: Int, p4: Int) {
        TODO("not implemented")
    }

    override fun surfaceChanged(p0: SurfaceHolder?, p1: Int, p2: Int, p3: Int) {
        mCamera?.apply {
            parameters?.also { params ->
                params.setPictureSize(500, 500)
                requestLayout()
                parameters = params
            }

            startPreview()
        }
    }

    override fun surfaceCreated(p0: SurfaceHolder?) {
        TODO("not implemented") //To change body of created functions use File | Settings | File Templates.
    }

    override fun surfaceDestroyed(p0: SurfaceHolder?) {
        mCamera?.stopPreview() //To change body of created functions use File | Settings | File Templates.
    }

    private fun stopPreviewAndFreeCamera() {
        mCamera?.apply {
            // Call stopPreview() to stop updating the preview surface.
            stopPreview()

            // Important: Call release() to release the camera for use by other
            // applications. Applications should release the camera immediately
            // during onPause() and re-open() it during onResume()).
            release()

            mCamera = null
        }
    }

    fun setCamera(camera: Camera?) {
        if (mCamera == camera) {
            return
        }

        stopPreviewAndFreeCamera()

        mCamera = camera

        mCamera?.apply {
            mSupportedPreviewSizes = parameters.supportedPreviewSizes
            requestLayout()

            try {
                setPreviewDisplay(mHolder)
            } catch (e: IOException) {
                e.printStackTrace()
            }

            // Important: Call startPreview() to start updating the preview
            // surface. Preview must be started before you can take a picture.
            startPreview()
        }
    }
}