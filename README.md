<h1 align="center">🤖 NPC Detection and Patrol System (Roblox Studio)</h1>

<p align="center">
  A smart AI behavior system for Roblox NPCs.<br>
  Detects players, patrols points, avoids obstacles, and respects stealth zones.
</p>

<hr>

<h2>🚩 Features</h2>

<ul>
  <li>👁️ Detects players within a defined range</li>
  <li>🏃‍♂️ Chases players using shortest valid path</li>
  <li>🛑 Ignores hidden players inside designated "cover zones"</li>
  <li>🧭 Patrols predefined destinations when idle</li>
  <li>🧱 Automatically avoids obstacles via <code>PathfindingService</code></li>
  <li>🔧 Modular and customizable</li>
</ul>

<hr>

<h2>🛠️ Technologies Used</h2>

<ul>
  <li>Roblox Studio (Lua scripting)</li>
  <li>PathfindingService</li>
  <li>CollectionService (for cover zone tagging)</li>
  <li>Region3, Raycasting, and Magnitude logic</li>
</ul>

<hr>

<h2>📁 Project Structure</h2>

<pre>
NPC-Detection-System/
├── NPCController.lua        Main AI logic
├── PathfindingModule.lua    Smart path generation
├── PatrolManager.lua        Destination patrol system
├── CoverZoneHandler.lua     Hiding zone detection
├── ConfigurationModule.lua  All parameters and settings
└── README.md
</pre>

<hr>

<h2>🚀 Getting Started</h2>

<ol>
  <li>Clone or download the repository</li>
  <li>Import the Lua scripts into your Roblox Studio project</li>
  <li>Tag hiding zones using <code>CollectionService</code></li>
  <li>Configure settings in <code>ConfigurationModule.lua</code></li>
  <li>Test it in Play mode!</li>
</ol>

<hr>

<h2>📜 Development Journey</h2>

<p>
  I developed this project during my high school years, as part of a mini side project. 
  It was submitted to a small community tournament called <strong>ZBX</strong> and — 
  to my surprise — it made it to the <strong>Top 67</strong>. This was one of my first experiments with AI behavior in Roblox Studio.
</p>

<hr>

<h2>📄 License</h2>

<p>This project is open-source under the MIT License.</p>

<hr>

<h2>📧 Contact</h2>

<p>Created by <strong>Nguyễn Duy Khánh</strong>. Feel free to fork, contribute, or report issues!</p>
