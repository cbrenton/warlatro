import { on } from "@rcade/plugin-input-classic";

window.initRcadeBridge = function () {
	on("press", (event) => {
		if (event.player === 1 && window._godot_input_cb) {
			window._godot_input_cb(event.button, event.pressed);
		}
	});
};
