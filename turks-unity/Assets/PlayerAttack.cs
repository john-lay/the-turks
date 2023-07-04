using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerAttack : MonoBehaviour
{
    public Animator animator;
    public ProjectileBehaviour projectilePrefab;
    public ProjectileSplash projectileSplashPrefab;
    public Transform launchOffset;

    private void Update()
    {
        if (Input.GetButtonDown("Fire1"))
        {
            Debug.Log("Fire 1 (ctrl) pressed");
            animator.SetBool("Attacking",  true);
        }
    }

    /// <summary>
    /// Function called as an `Animation Event` on the `player-attack-down.anim` animation 
    /// </summary>
    public void AttackComplete()
    {
        Debug.Log("Attack animation complete");
        animator.SetBool("Attacking",  false);
        Instantiate(projectilePrefab, launchOffset.position, transform.rotation);
    }

    /// <summary>
    /// Function called as an `Animation Event` on the `player-attack-down.anim` animation 
    /// </summary>
    public void BeginShotgunSplash()
    {
        Debug.Log("Starting shotgun splash animation");
        Instantiate(projectileSplashPrefab, launchOffset.position, transform.rotation);
    }
}
