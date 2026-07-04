/* ==========================================================================
   Onterior Enterprises — shared behaviour for custom sections
   - Scroll-reveal (IntersectionObserver)
   - Animated stat counters
   Safe to load once; guards against double-init and respects reduced motion.
   ========================================================================== */
(function () {
  'use strict';
  if (window.__onteriorInit) return;
  window.__onteriorInit = true;

  var reduceMotion = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  function initReveal(root) {
    var els = (root || document).querySelectorAll('.ont-reveal:not(.ont-observed)');
    if (!('IntersectionObserver' in window) || reduceMotion) {
      els.forEach(function (el) { el.classList.add('ont-in', 'ont-observed'); });
      return;
    }
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) { e.target.classList.add('ont-in'); io.unobserve(e.target); }
      });
    }, { threshold: 0.15 });
    els.forEach(function (el) { el.classList.add('ont-observed'); io.observe(el); });
  }

  function animateCounter(el) {
    var target = parseFloat(el.getAttribute('data-target')) || 0;
    if (reduceMotion) { el.textContent = target.toLocaleString(); return; }
    var duration = 1600, start = null;
    function tick(now) {
      if (start === null) start = now;
      var p = Math.min((now - start) / duration, 1);
      var eased = 1 - Math.pow(1 - p, 3);
      el.textContent = Math.round(target * eased).toLocaleString();
      if (p < 1) requestAnimationFrame(tick);
    }
    requestAnimationFrame(tick);
  }

  function initCounters(root) {
    var els = (root || document).querySelectorAll('.ont-counter:not(.ont-counted)');
    if (!('IntersectionObserver' in window)) {
      els.forEach(function (el) { el.classList.add('ont-counted'); animateCounter(el); });
      return;
    }
    var io = new IntersectionObserver(function (entries) {
      entries.forEach(function (e) {
        if (e.isIntersecting) { e.target.classList.add('ont-counted'); animateCounter(e.target); io.unobserve(e.target); }
      });
    }, { threshold: 0.5 });
    els.forEach(function (el) { io.observe(el); });
  }

  function init(root) { initReveal(root); initCounters(root); }

  document.addEventListener('DOMContentLoaded', function () { init(document); });
  if (document.readyState !== 'loading') init(document);

  // Re-init inside the theme editor when a section is added/reloaded.
  document.addEventListener('shopify:section:load', function (e) { init(e.target); });
})();
