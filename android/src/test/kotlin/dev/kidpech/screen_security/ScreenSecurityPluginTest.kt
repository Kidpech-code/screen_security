package dev.kidpech.screen_security

import android.app.Activity
import android.view.Window
import android.view.WindowManager
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import org.mockito.Mockito.never
import org.mockito.Mockito.verify
import kotlin.test.Test

internal class ScreenSecurityPluginTest {

    // ── Helpers ──────────────────────────────────────────────────────────────

    private fun buildPlugin(withActivity: Boolean = false): Pair<KidpechScreenSecurityPlugin, Activity?> {
        val plugin = KidpechScreenSecurityPlugin()
        if (!withActivity) return plugin to null

        val window = Mockito.mock(Window::class.java)
        val activity = Mockito.mock(Activity::class.java)
        Mockito.`when`(activity.window).thenReturn(window)

        val binding = Mockito.mock(ActivityPluginBinding::class.java)
        Mockito.`when`(binding.activity).thenReturn(activity)
        plugin.onAttachedToActivity(binding)

        return plugin to activity
    }

    // ── No-activity error paths ───────────────────────────────────────────────

    @Test
    fun onMethodCall_enableScreenSecurity_withoutActivity_returnsError() {
        val (plugin, _) = buildPlugin(withActivity = false)
        val result: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)

        plugin.onMethodCall(MethodCall("enableScreenSecurity", null), result)

        verify(result).error("NO_ACTIVITY", "Activity is not available", null)
    }

    @Test
    fun onMethodCall_disableScreenSecurity_withoutActivity_returnsError() {
        val (plugin, _) = buildPlugin(withActivity = false)
        val result: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)

        plugin.onMethodCall(MethodCall("disableScreenSecurity", null), result)

        verify(result).error("NO_ACTIVITY", "Activity is not available", null)
    }

    // ── Unknown method ────────────────────────────────────────────────────────

    @Test
    fun onMethodCall_unknownMethod_returnsNotImplemented() {
        val (plugin, _) = buildPlugin(withActivity = false)
        val result: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)

        plugin.onMethodCall(MethodCall("unknownMethod", null), result)

        verify(result).notImplemented()
        verify(result, never()).success(Mockito.any())
        verify(result, never()).error(Mockito.any(), Mockito.any(), Mockito.any())
    }

    // ── Happy-path with activity ──────────────────────────────────────────────

    @Test
    fun onMethodCall_enableScreenSecurity_withActivity_setsFlagSecure() {
        val (plugin, activity) = buildPlugin(withActivity = true)
        val result: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)

        plugin.onMethodCall(MethodCall("enableScreenSecurity", null), result)

        verify(activity!!.window).setFlags(
            WindowManager.LayoutParams.FLAG_SECURE,
            WindowManager.LayoutParams.FLAG_SECURE,
        )
        verify(result).success(null)
    }

    @Test
    fun onMethodCall_disableScreenSecurity_withActivity_clearsFlagSecure() {
        val (plugin, activity) = buildPlugin(withActivity = true)
        val result: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)

        plugin.onMethodCall(MethodCall("disableScreenSecurity", null), result)

        verify(activity!!.window).clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
        verify(result).success(null)
    }

    // ── Activity lifecycle ────────────────────────────────────────────────────

    @Test
    fun onDetachedFromActivity_enableScreenSecurity_returnsError() {
        val (plugin, _) = buildPlugin(withActivity = true)
        plugin.onDetachedFromActivity()

        val result: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(MethodCall("enableScreenSecurity", null), result)

        verify(result).error("NO_ACTIVITY", "Activity is not available", null)
    }

    @Test
    fun onDetachedFromActivityForConfigChanges_enableScreenSecurity_returnsError() {
        val (plugin, _) = buildPlugin(withActivity = true)
        plugin.onDetachedFromActivityForConfigChanges()

        val result: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(MethodCall("enableScreenSecurity", null), result)

        verify(result).error("NO_ACTIVITY", "Activity is not available", null)
    }

    @Test
    fun onReattachedToActivityForConfigChanges_restoresActivity() {
        val (plugin, originalActivity) = buildPlugin(withActivity = true)
        plugin.onDetachedFromActivityForConfigChanges()

        // Reattach with the same (or a new) activity
        val window = Mockito.mock(Window::class.java)
        val newActivity = Mockito.mock(Activity::class.java)
        Mockito.`when`(newActivity.window).thenReturn(window)
        val binding = Mockito.mock(ActivityPluginBinding::class.java)
        Mockito.`when`(binding.activity).thenReturn(newActivity)
        plugin.onReattachedToActivityForConfigChanges(binding)

        val result: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(MethodCall("enableScreenSecurity", null), result)

        verify(result).success(null)
    }
}
