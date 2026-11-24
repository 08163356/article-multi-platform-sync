/**
 * 只启动扩展桥，不走 stdio MCP。
 * 给 8.135.9.12 上的 systemd 用：WebSocket 对外，HTTP 只在本机。
 */
import { ExtensionBridge } from './ws-bridge.js'

const port = parseInt(process.env.SYNC_WS_PORT || '9527', 10)
const bridge = new ExtensionBridge(port)

await bridge.start()
console.error(`[bridge-only] WebSocket :${port}  HTTP 127.0.0.1:${port + 1}`)
