/*
 * lightship health check status for etherpad-lite
 *
 * This plugin starts a webserver that accepts HTTP requests on a specific port
 * to check the status of the etherpad-lite server. You can configure it's
 * behavior by defining the following environment variables:
 *
 * EP_LIGHTSHIP_DETECT_KUBERNETES: should lightship detect its environment?
 * i.e. local or k8s (default: false).
 *
 * EP_LIGHTSHIP_PORT: the lightship server port (default: 9002).
 */

const lightship = require('lightship');

/* Etherpad-lite plugin hook function signature is expecting the following
 * arguments:
 *
 *   - hook_name: the name of the called hook
 *   - args: the execution context (depends on called hook)
 *   - cb: hook callback function
 *
 * We are targetting the expressCreateServer hook that brings the following
 * paremeters to the context:
 *
 *   - app: the main express application object
 *   - server: the http server object
 *
 * For reference, see:
 * https://etherpad.org/doc/v1.8.0-beta.1/#index_expresscreateserver
 */
exports.start = function(hook_name, args, cb) {
  let ls = lightship.createLightship({
    detectKubernetes: process.env.EP_LIGHTSHIP_DETECT_KUBERNETES === 'true',
    port: process.env.EP_LIGHTSHIP_PORT || 9002,
  });

  ls.registerShutdownHandler(() => {
    args.server.close();
  });

  // Lightship default state is "SERVER_IS_NOT_READY". Therefore, you must signal
  // that the server is now ready to accept connections.
  ls.signalReady();
};
