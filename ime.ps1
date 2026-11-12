# Switch Microsoft Pinyin conversion mode for the foreground window.
# Usage: ime.ps1 zh | en
param(
	[Parameter(Mandatory = $true)]
	[ValidateSet("zh", "en")]
	[string]$Mode
)

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;

public static class YaziWinIme {
	public const int WM_IME_CONTROL = 0x0283;
	public const int IMC_GETCONVERSIONMODE = 0x0001;
	public const int IMC_SETCONVERSIONMODE = 0x0002;
	public const int IME_CMODE_NATIVE = 0x0001;

	[DllImport("user32.dll")]
	public static extern IntPtr GetForegroundWindow();

	[DllImport("imm32.dll")]
	public static extern IntPtr ImmGetDefaultIMEWnd(IntPtr hWnd);

	[DllImport("user32.dll")]
	public static extern IntPtr SendMessage(IntPtr hWnd, int msg, IntPtr wParam, IntPtr lParam);
}
"@

$hwnd = [YaziWinIme]::GetForegroundWindow()
if ($hwnd -eq [IntPtr]::Zero) { exit 1 }

$ime = [YaziWinIme]::ImmGetDefaultIMEWnd($hwnd)
if ($ime -eq [IntPtr]::Zero) { exit 2 }

$cur = [YaziWinIme]::SendMessage(
	$ime,
	[YaziWinIme]::WM_IME_CONTROL,
	[IntPtr][YaziWinIme]::IMC_GETCONVERSIONMODE,
	[IntPtr]::Zero
).ToInt32()

if ($Mode -eq "zh") {
	$next = $cur -bor [YaziWinIme]::IME_CMODE_NATIVE
} else {
	$next = $cur -band (-bnot [YaziWinIme]::IME_CMODE_NATIVE)
}

if ($next -eq $cur) { exit 0 }

[void][YaziWinIme]::SendMessage(
	$ime,
	[YaziWinIme]::WM_IME_CONTROL,
	[IntPtr][YaziWinIme]::IMC_SETCONVERSIONMODE,
	[IntPtr]$next
)
exit 0
