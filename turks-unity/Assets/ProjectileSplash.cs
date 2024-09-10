using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProjectileSplash : MonoBehaviour
{
    /// <summary>
    /// Function called as an `Animation Event` on the `projectile-down.anim` animation 
    /// </summary>
    public void EndShotgunSplash()
    {
        Debug.Log("Shotgun splash animation ended");
        Destroy(gameObject);
    }
}
