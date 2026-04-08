(() => {
  // node_modules/@rcade/plugin-input-classic/dist/index.js
  var PluginChannel = class _PluginChannel {
    port;
    channel;
    static async acquire(name, version) {
      const nonce = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
      return new Promise((resolve, reject) => {
        const listener = (event) => {
          if (event.data?.type === "plugin_channel" && event.data?.nonce === nonce) {
            const port = event.ports[0];
            if ("error" in event.data) {
              window.removeEventListener("message", listener);
              reject(new Error(event.data.error));
              return;
            }
            const { channel } = event.data;
            if (!channel?.name || !channel?.version || !port) {
              console.warn("Invalid plugin_channel event", event.data);
              return;
            }
            window.removeEventListener("message", listener);
            const pluginChannel = new _PluginChannel(port, channel);
            resolve(pluginChannel);
          }
        };
        window.addEventListener("message", listener);
        window.parent.postMessage({
          type: "acquire_plugin_channel",
          nonce,
          channel: { name, version }
        }, "*");
      });
    }
    constructor(port, channel) {
      this.port = port;
      this.channel = channel;
    }
    getPort() {
      return this.port;
    }
    getVersion() {
      return String(this.channel.version);
    }
  };
  var PLAYER_1 = {
    DPAD: { up: false, down: false, left: false, right: false },
    A: false,
    B: false
  };
  var PLAYER_2 = {
    DPAD: { up: false, down: false, left: false, right: false },
    A: false,
    B: false
  };
  var SYSTEM = {
    ONE_PLAYER: false,
    TWO_PLAYER: false
  };
  var STATUS = { connected: false };
  var eventListeners = {
    press: [],
    inputStart: [],
    inputEnd: []
  };
  function on(event, callback) {
    eventListeners[event].push(callback);
    return () => {
      const idx = eventListeners[event].indexOf(callback);
      if (idx !== -1)
        eventListeners[event].splice(idx, 1);
    };
  }
  function emit(event, data) {
    eventListeners[event].forEach((cb) => cb(data));
  }
  (async () => {
    const channel = await PluginChannel.acquire("@rcade/input-classic", "^1.0.0");
    STATUS.connected = true;
    channel.getPort().onmessage = (event) => {
      const { type, player, button, pressed } = event.data;
      if (type === "button") {
        if (player === 1) {
          if (button === "A" || button === "B") {
            PLAYER_1[button] = pressed;
          } else if (button === "UP" || button === "DOWN" || button === "LEFT" || button === "RIGHT") {
            PLAYER_1.DPAD[button.toLowerCase()] = pressed;
          }
        } else if (player === 2) {
          if (button === "A" || button === "B") {
            PLAYER_2[button] = pressed;
          } else if (button === "UP" || button === "DOWN" || button === "LEFT" || button === "RIGHT") {
            PLAYER_2.DPAD[button.toLowerCase()] = pressed;
          }
        }
        if (pressed) {
          emit("inputStart", { player, button, pressed, type });
          emit("press", { player, button, pressed, type });
        } else {
          emit("inputEnd", { player, button, pressed, type });
        }
      } else if (type === "system") {
        if (button === "ONE_PLAYER") {
          SYSTEM.ONE_PLAYER = pressed;
        } else if (button === "TWO_PLAYER") {
          SYSTEM.TWO_PLAYER = pressed;
        }
        if (pressed) {
          emit("inputStart", { button, pressed, type });
          emit("press", { button, pressed, type });
        } else {
          emit("inputEnd", { button, pressed, type });
        }
      }
    };
  })();
  if (void 0) {
  }

  // rcade_bridge.js
  window.initRcadeBridge = function() {
    on("press", (event) => {
      if (event.player === 1 && window._godot_input_cb) {
        window._godot_input_cb(event.button, event.pressed);
      }
    });
  };
})();
