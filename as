<!--
  Agent Lifecycle Diagram — UBS style
  Drop into any MkDocs .md page:

    --8<-- "docs/includes/agent-lifecycle-ubs.html"

  Requires in mkdocs.yml:
    markdown_extensions:
      - pymdownx.snippets

  No JS. No external dependencies. Pure HTML + CSS.
  Fonts load from Google Fonts (IBM Plex Sans + IBM Plex Mono).
  Falls back gracefully to Helvetica Neue / system monospace.
-->
<style>
@import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Sans:wght@300;400;500;700&family=IBM+Plex+Mono:wght@400;500&display=swap');

.ubs{font-family:'IBM Plex Sans','Helvetica Neue',Helvetica,Arial,sans-serif;background:#ffffff;border:1.5px solid #1a1a1a;color:#1a1a1a;margin:1.5rem 0}
.ubs-header{background:#E60028;padding:14px 24px 13px;display:flex;align-items:baseline;justify-content:space-between}
.ubs-header-title{font-size:11px;font-weight:700;letter-spacing:3px;text-transform:uppercase;color:#fff}
.ubs-header-sub{font-family:'IBM Plex Mono',monospace;font-size:9px;color:rgba(255,255,255,.6);letter-spacing:1px}
.ubs-pipeline{display:grid;grid-template-columns:1fr 44px 1fr 44px 1fr 44px 1fr;align-items:stretch;border-bottom:1px solid #e0e0e0}
.ubs-connector{display:flex;flex-direction:column;align-items:center;justify-content:flex-start;padding-top:48px;border-right:1px solid #e8e8e8;border-left:1px solid #e8e8e8;background:#fafafa}
.ubs-arrow-wrap{display:flex;flex-direction:column;align-items:center;gap:0}
.ubs-arrow-label{font-family:'IBM Plex Mono',monospace;font-size:8px;color:#999;letter-spacing:.5px;writing-mode:vertical-lr;transform:rotate(180deg);white-space:nowrap;margin:6px 0;text-transform:uppercase}
.ubs-arrow-shaft{width:1px;height:20px;background:#bbb}
.ubs-arrow-head{width:0;height:0;border-left:4px solid transparent;border-right:4px solid transparent;border-top:6px solid #E60028}
.ubs-stage{border-right:1px solid #e8e8e8}
.ubs-stage:last-child{border-right:none}
.ubs-stage-head{padding:12px 16px 11px;border-bottom:2px solid #1a1a1a;display:flex;align-items:center;gap:10px;background:#f7f7f7}
.ubs-stage-num{font-family:'IBM Plex Mono',monospace;font-size:11px;font-weight:500;color:#E60028;min-width:14px}
.ubs-stage-name{font-size:10px;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:#1a1a1a}
.ubs-body{padding:12px 14px 16px;display:flex;flex-direction:column;gap:0}
.ubs-node{border:1px solid #d8d8d8;border-left:3px solid #1a1a1a;padding:7px 10px 6px;background:#fff;display:flex;flex-direction:column;gap:2px;margin-bottom:5px}
.ubs-node:hover{border-left-color:#E60028;background:#fef9f9}
.ubs-node-name{font-size:11.5px;font-weight:500;color:#1a1a1a;line-height:1.2}
.ubs-node-sub{font-family:'IBM Plex Mono',monospace;font-size:9px;color:#888;letter-spacing:.3px}
.ubs-node.accent{border-left-color:#E60028;background:#fff8f8}
.ubs-node.accent .ubs-node-name{color:#E60028}
.ubs-node.store{border-left-color:#555;border-style:dashed;border-left-style:solid}
.ubs-flow{display:flex;align-items:center;gap:3px;padding:1px 2px 4px;position:relative}
.ubs-flow-line{flex:1;height:1px;background:#d0d0d0}
.ubs-flow-tip{width:0;height:0;border-top:3px solid transparent;border-bottom:3px solid transparent;border-left:5px solid #bbb}
.ubs-flow-label{font-family:'IBM Plex Mono',monospace;font-size:8px;color:#aaa;letter-spacing:.5px;text-transform:uppercase;position:absolute;left:50%;transform:translateX(-50%);top:-8px;background:#fff;padding:0 3px;white-space:nowrap}
.ubs-subgroup{border:1px solid #d8d8d8;border-top:2px solid #1a1a1a;margin-bottom:5px;background:#fff}
.ubs-subgroup-label{font-family:'IBM Plex Mono',monospace;font-size:8px;font-weight:500;letter-spacing:2px;text-transform:uppercase;color:#888;padding:5px 10px 4px;border-bottom:1px solid #ebebeb;background:#f9f9f9}
.ubs-subgroup-body{padding:8px 8px 6px;display:flex;flex-direction:column;gap:4px}
.ubs-subgroup.red{border-top-color:#E60028}
.ubs-subgroup.red .ubs-subgroup-label{color:#E60028}
.ubs-provision{display:flex;align-items:center;gap:6px;padding:3px 2px 5px}
.ubs-provision-line{flex:1;height:0;border-top:1px dashed #ccc}
.ubs-provision-label{font-family:'IBM Plex Mono',monospace;font-size:8px;color:#bbb;letter-spacing:1px;text-transform:uppercase}
.ubs-ctx{border:1px solid #e8e8e8;border-top:1px solid #d0d0d0;padding:7px 10px;margin-top:4px;background:#fafafa}
.ubs-ctx-label{font-family:'IBM Plex Mono',monospace;font-size:8px;font-weight:500;letter-spacing:2px;text-transform:uppercase;color:#E60028;margin-bottom:3px}
.ubs-ctx-desc{font-size:10px;color:#777;line-height:1.5}
.ubs-footer{display:flex;align-items:center;justify-content:space-between;padding:9px 24px 10px;border-top:1px solid #e0e0e0;background:#f7f7f7}
.ubs-legend{display:flex;align-items:center;gap:18px}
.ubs-legend-item{display:flex;align-items:center;gap:6px;font-size:9.5px;color:#888;letter-spacing:.5px;text-transform:uppercase;font-family:'IBM Plex Mono',monospace}
.ubs-ref{font-family:'IBM Plex Mono',monospace;font-size:9px;color:#bbb;letter-spacing:1px}
</style>

<div class="ubs">
  <div class="ubs-header">
    <span class="ubs-header-title">AI Product lifecycle</span>
    <span class="ubs-header-sub">E2E</span>
  </div>

  <div class="ubs-pipeline">

    <div class="ubs-stage">
      <div class="ubs-stage-head"><span class="ubs-stage-num">01</span><span class="ubs-stage-name">Repository</span></div>
      <div class="ubs-body">
        <div class="ubs-node"><span class="ubs-node-name">My fancy agent</span><span class="ubs-node-sub">agent code</span></div>
        <div class="ubs-node"><span class="ubs-node-name">My app</span><span class="ubs-node-sub">application code</span></div>
        <div class="ubs-node store"><span class="ubs-node-name">Services</span><span class="ubs-node-sub">services manifests</span></div>
        <div class="ubs-ctx"><div class="ubs-ctx-label">DevCloud</div><div class="ubs-ctx-desc">Gitlab</div></div>
      </div>
    </div>

    <div class="ubs-connector"><div class="ubs-arrow-wrap"><div class="ubs-arrow-label">hand off</div><div class="ubs-arrow-shaft"></div><div class="ubs-arrow-head"></div></div></div>

    <div class="ubs-stage">
      <div class="ubs-stage-head"><span class="ubs-stage-num">02</span><span class="ubs-stage-name">Lab</span></div>
      <div class="ubs-body">
        <div class="ubs-node"><span class="ubs-node-name">Project</span><span class="ubs-node-sub">AI Product project aligned</span></div>
        <div class="ubs-flow" style="position:relative;padding-top:10px"><div class="ubs-flow-line"></div><div class="ubs-flow-tip"></div></div>
        <div class="ubs-flow" style="position:relative;padding-top:10px"><span class="ubs-flow-label">log + eval + validate runs</span><div class="ubs-flow-line"></div><div class="ubs-flow-tip"></div></div>
        <div class="ubs-node accent"><span class="ubs-node-name">Job</span><span class="ubs-node-sub">User & NPTA job run</span></div>
        <div class="ubs-node"><span class="ubs-node-name">Benchmarking</span><span class="ubs-node-sub">Testing</span></div>
        <div class="ubs-node"><span class="ubs-node-name">Lab deployment</span><span class="ubs-node-sub">Augmented models</span></div>
        <div class="ubs-ctx"><div class="ubs-ctx-label">AICE</div><div class="ubs-ctx-desc">AI development environment &amp;<br>evaluation</div></div>
      </div>
    </div>

    <div class="ubs-connector"><div class="ubs-arrow-wrap"><div class="ubs-arrow-label">promote</div><div class="ubs-arrow-shaft"></div><div class="ubs-arrow-head"></div></div></div>

    <div class="ubs-stage">
      <div class="ubs-stage-head"><span class="ubs-stage-num">03</span><span class="ubs-stage-name">Registry</span></div>
      <div class="ubs-body">
        <div class="ubs-node store"><span class="ubs-node-name">UC Catalog</span><span class="ubs-node-sub">AI Product versioned artifact store</span></div>
        <div class="ubs-flow" style="position:relative;padding-top:10px"><span class="ubs-flow-label">promote</span><div class="ubs-flow-line"></div><div class="ubs-flow-tip"></div></div>
        <div class="ubs-node"><span class="ubs-node-name">Experiments</span><span class="ubs-node-sub">run logs</span></div>
        <div class="ubs-node accent"><span class="ubs-node-name">Registry</span><span class="ubs-node-sub">promoted + signed</span></div>
        <div class="ubs-ctx"><div class="ubs-ctx-label">AIMART</div><div class="ubs-ctx-desc">Experiments, Versioning, Registry, Tracing, Signing</div></div>
      </div>
    </div>

    <div class="ubs-connector"><div class="ubs-arrow-wrap"><div class="ubs-arrow-label">trigger deploy</div><div class="ubs-arrow-shaft"></div><div class="ubs-arrow-head"></div></div></div>

    <div class="ubs-stage">
      <div class="ubs-stage-head"><span class="ubs-stage-num">04</span><span class="ubs-stage-name">Deployment</span></div>
      <div class="ubs-body">
        <div class="ubs-subgroup red">
          <div class="ubs-subgroup-label">EAIS pipeline</div>
          <div class="ubs-subgroup-body">
            <div class="ubs-node" style="margin-bottom:0;border-left-width:2px"><span class="ubs-node-name">Fetch</span><span class="ubs-node-sub">pull from registry</span></div>
            <div class="ubs-flow"><div class="ubs-flow-line"></div><div class="ubs-flow-tip"></div></div>
            <div class="ubs-node" style="margin-bottom:0;border-left-width:2px"><span class="ubs-node-name">Build</span><span class="ubs-node-sub">containerise + sign</span></div>
            <div class="ubs-flow"><div class="ubs-flow-line"></div><div class="ubs-flow-tip"></div></div>
            <div class="ubs-node" style="margin-bottom:0;border-left-width:2px"><span class="ubs-node-name">Publish</span><span class="ubs-node-sub">push to image repo</span></div>
            <div class="ubs-flow"><div class="ubs-flow-line"></div><div class="ubs-flow-tip"></div></div>
            <div class="ubs-node accent" style="margin-bottom:0"><span class="ubs-node-name">Deploy action [Dev, Test, Uat, Prep, Prod]</span><span class="ubs-node-sub">trigger infra plan</span></div>
            <div class="ubs-node accent" style="margin-bottom:0"><span class="ubs-node-name">CHR [Prod]</span><span class="ubs-node-sub">Change Management</span></div>
          </div>
        </div>
        <div class="ubs-provision"><div class="ubs-provision-line"></div><span class="ubs-provision-label">provision</span><div class="ubs-provision-line"></div></div>
        <div class="ubs-subgroup">
          <div class="ubs-subgroup-label">Cloud targets [UK8s, AKS]</div>
          <div class="ubs-subgroup-body">
            <div class="ubs-node" style="margin-bottom:0;border-left-width:2px"><span class="ubs-node-name">TF backend</span><span class="ubs-node-sub">state + locking</span></div>
            <div class="ubs-node" style="margin-bottom:0;border-left-width:2px"><span class="ubs-node-name">TF infra</span><span class="ubs-node-sub">k8s / cloud resources</span></div>
            <div class="ubs-node store accent" style="margin-bottom:0"><span class="ubs-node-name">Live services</span><span class="ubs-node-sub">running in production</span></div>
          </div>
        </div>
      </div>
    </div>

  </div>

  <div class="ubs-footer">
    <div class="ubs-legend">
      <div class="ubs-legend-item"><div style="width:14px;height:3px;background:#1a1a1a"></div>standard node</div>
      <div class="ubs-legend-item"><div style="width:14px;height:3px;background:#E60028"></div>active / promoted</div>
      <div class="ubs-legend-item"><div style="width:14px;height:0;border-top:1px dashed #aaa"></div></div>
    </div>
  </div>
</div>
