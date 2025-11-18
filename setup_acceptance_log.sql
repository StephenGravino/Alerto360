-- Create acceptance_log table to track responder actions
CREATE TABLE IF NOT EXISTS acceptance_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    incident_id INT NOT NULL,
    responder_id INT NOT NULL,
    action VARCHAR(50) NOT NULL,
    timestamp DATETIME NOT NULL,
    FOREIGN KEY (incident_id) REFERENCES incidents(id) ON DELETE CASCADE,
    FOREIGN KEY (responder_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Add accepted_at column to incidents table if it doesn't exist
ALTER TABLE incidents ADD COLUMN IF NOT EXISTS accepted_at DATETIME NULL;

-- Add completed_at column to incidents table if it doesn't exist
ALTER TABLE incidents ADD COLUMN IF NOT EXISTS completed_at DATETIME NULL;

-- Update incidents status ENUM to include 'completed' status
ALTER TABLE incidents MODIFY COLUMN status ENUM('pending', 'accepted', 'done', 'resolved', 'completed', 'accept and complete') DEFAULT 'pending';

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_acceptance_log_incident ON acceptance_log(incident_id);
CREATE INDEX IF NOT EXISTS idx_acceptance_log_responder ON acceptance_log(responder_id);
CREATE INDEX IF NOT EXISTS idx_incidents_accepted_at ON incidents(accepted_at);
CREATE INDEX IF NOT EXISTS idx_incidents_completed_at ON incidents(completed_at);
