// MongoDB initialization script for edX platform

print("=== Initializing edX MongoDB Database ===");

// Switch to admin database
db = db.getSiblingDB('admin');

// Create edX user with read/write permissions
db.createUser({
  user: "edxapp",
  pwd: "password",
  roles: [
    {
      role: "readWrite",
      db: "edxapp"
    },
    {
      role: "dbAdmin",
      db: "edxapp"
    }
  ]
});

// Switch to edxapp database
db = db.getSiblingDB('edxapp');

// Create collections that edX expects
db.createCollection("modulestore");
db.createCollection("fs.files");
db.createCollection("fs.chunks");

// Create indexes for better performance
db.modulestore.createIndex({"_id.org": 1, "_id.course": 1, "_id.name": 1});
db.modulestore.createIndex({"_id.category": 1});
db.modulestore.createIndex({"definition.children": 1});

// Create sample course structure (optional)
db.modulestore.insertOne({
  "_id": {
    "tag": "i4x",
    "org": "edX",
    "course": "DemoX",
    "category": "course",
    "name": "Demo_Course",
    "revision": null
  },
  "definition": {
    "children": [],
    "data": {
      "display_name": "Demo Course",
      "start": new Date(),
      "enrollment_start": new Date(),
      "enrollment_end": new Date(new Date().getTime() + 365*24*60*60*1000)
    }
  },
  "metadata": {
    "display_name": "Demo Course",
    "created": new Date(),
    "modified": new Date()
  }
});

print("✅ MongoDB setup completed successfully!");
print("📊 Database: edxapp");
print("👤 User: edxapp");
print("📁 Collections created:");
print("  - modulestore (course content)");
print("  - fs.files (file storage)"); 
print("  - fs.chunks (file chunks)");
print("🔍 Indexes created for performance optimization");

// Show database stats
print("\n📈 Database Statistics:");
printjson(db.stats());
