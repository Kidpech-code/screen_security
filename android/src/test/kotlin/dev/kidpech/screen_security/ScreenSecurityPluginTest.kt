package dev.kidpech.screen_security

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.mockito.Mockito
import kotlin.test.Test

internal class ScreenSecurityPluginTest {
    @Test
    fun onMethodCall_enableScreenSecurity_withoutActivity_returnsError() {
        val plugin = KidpechScreenSecurityPlugin()

        val call = MethodCall("enableScreenSecurity", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).error("NO_ACTIVITY", "Activity is not available", null)
    }

    @Test
    fun onMethodCall_disableScreenSecurity_withoutActivity_returnsError() {
        val plugin = KidpechScreenSecurityPlugin()

        val call = MethodCall("disableScreenSecurity", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).error("NO_ACTIVITY", "Activity is not available", null)
    }

    @Test
    fun onMethodCall_unknownMethod_returnsNotImplemented() {
        val plugin = KidpechScreenSecurityPlugin()

        val call = MethodCall("unknownMethod", null)
        val mockResult: MethodChannel.Result = Mockito.mock(MethodChannel.Result::class.java)
        plugin.onMethodCall(call, mockResult)

        Mockito.verify(mockResult).notImplemented()
    }
}
