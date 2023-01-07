using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using TMPro;
using Random = UnityEngine.Random;

namespace BNG {
    public class Zippo : MonoBehaviour
    {
        private int fireInt;
        private int fireIntCurrent = 0;
        private bool isOpen = false;
        private bool isFire = false;
        private bool isTime = false;
        private bool isGrab = false;

        [SerializeField] private GameObject _zippoOpen;
        [SerializeField] private GameObject _zippoClose;
        [SerializeField] private GameObject _ZippoFlame;
        [SerializeField] private GameObject _ZippoFlameLight;
        [SerializeField] private GameObject _CigarFlameTrigger;

        [SerializeField] private AudioSource _audioSource;
        [SerializeField] private AudioClip ZippoOpen;
        [SerializeField] private AudioClip ZippoClose;
        [SerializeField] private AudioClip ZippoLighter_1;
        [SerializeField] private AudioClip ZippoLighter_2;
        [SerializeField] private AudioClip ZippoLighter_3;

        private void Start()
        {
            _zippoClose.SetActive(true);
            _zippoOpen.SetActive(false);
            _ZippoFlame.SetActive(false);
            _ZippoFlameLight.SetActive(false);
            _CigarFlameTrigger.SetActive(false);
            isOpen = false;
            fireInt = Random.Range(0, 3);
        }

        public void ZippoOpenClose()
        {
            if(isOpen == false)
            {
                _zippoClose.SetActive(false);
                _zippoOpen.SetActive(true);
                _audioSource.Stop();
                _audioSource.PlayOneShot(ZippoOpen);
                isOpen = true;
            }
            else
            {
                _zippoClose.SetActive(true);
                _zippoOpen.SetActive(false);
                _ZippoFlame.SetActive(false);
                _ZippoFlameLight.SetActive(false);
                _CigarFlameTrigger.SetActive(false);
                isOpen = false;
                isFire = false;
                _audioSource.Stop();
                _audioSource.PlayOneShot(ZippoClose);
                fireInt = Random.Range(1, 3);
            }
        }
        public void StickZippoOpen()
        {
            if(isOpen == false)
            {
                _zippoClose.SetActive(false);
                _zippoOpen.SetActive(true);
                _audioSource.Stop();
                _audioSource.PlayOneShot(ZippoOpen);
                isOpen = true;
            }       
        }
        public void StickZippoClose()
        {
            if(isOpen == true)
            {
                _zippoClose.SetActive(true);
                _zippoOpen.SetActive(false);
                _ZippoFlame.SetActive(false);
                _ZippoFlameLight.SetActive(false);
                _CigarFlameTrigger.SetActive(false);
                isOpen = false;
                isFire = false;
                _audioSource.Stop();
                _audioSource.PlayOneShot(ZippoClose);
                fireInt = Random.Range(1, 3);
            }
        }

        public void FireZippo()
        {
            StartCoroutine(FireZippoCoroutine());
        }
        public void ZippoGrabbed()
        {
            isGrab = true;
        }
        public void ZippoReleased()
        {
            isGrab = false;
        }

        IEnumerator FireZippoCoroutine()
        {
            if(isOpen == true)
            {
                if (fireIntCurrent <= fireInt)
                {
                    yield return new WaitForSeconds(0.2f);
                    _audioSource.PlayOneShot(ZippoLighter_1);
                    fireIntCurrent++;
                }
                else
                {
                    if(isFire == false)
                    {
                        isFire = true;
                        _audioSource.Stop();
                        _audioSource.PlayOneShot(ZippoLighter_1);
                        yield return new WaitForSeconds(0.2f);
                        _audioSource.PlayOneShot(ZippoLighter_2);
                        _ZippoFlame.SetActive(true);
                        _ZippoFlameLight.SetActive(true);
                        _CigarFlameTrigger.SetActive(true);
                        yield return new WaitForSeconds(0.25f);
                        _audioSource.PlayOneShot(ZippoLighter_3);
                        _audioSource.loop = true;
                        fireIntCurrent = 0;
                    }
                }
            }
            yield return null;
        }


        // SNAP ZONE
        public enum RotationMechanic
        {
            Snap,
            Smooth
        }
        
            [Header("Input")]
            [Tooltip("Set to false to skip Update")]
            public bool AllowInput = true;

            [Tooltip("Used to determine whether to turn left / right. This can be an X Axis on the thumbstick, for example. -1 to snap left, 1 to snap right.")]
            public List<InputAxis> inputAxis = new List<InputAxis>() { InputAxis.RightThumbStickAxis };

            [Tooltip("Unity Input Action used to rotate the player")]
            public InputActionReference RotateAction;

            [Header("Smooth / Snap Turning")]
            [Tooltip("Snap rotation will rotate a fixed amount of degrees on turn. Smooth will linearly rotate the player.")]
            public RotationMechanic RotationType = RotationMechanic.Snap;


            float recentSnapTurnTime;

            /// <summary>
            /// How much to rotate this frame
            /// </summary>
            float rotationAmount = 0;

            float xAxis;
            float previousXInput;

            #region Events
            public delegate void OnBeforeRotateAction();
            public static event OnBeforeRotateAction OnBeforeRotate;

            public delegate void OnAfterRotateAction();
            public static event OnAfterRotateAction OnAfterRotate;
            #endregion

            void Update()
            {

                if (!AllowInput)
                {
                    return;
                }

                xAxis = GetAxisInput();

                if (RotationType == RotationMechanic.Snap)
                {
                    DoSnapRotation(xAxis);
                }

            }

            /// <summary>
            /// Return a float between -1 and 1 to determine which direction to turn the character
            /// </summary>
            /// <returns></returns>
            public virtual float GetAxisInput()
            {

                // Use the largest, non-zero value we find in our input list
                float lastVal = 0;

                // Check Raw Input
                if (inputAxis != null)
                {
                    for (int i = 0; i < inputAxis.Count; i++)
                    {
                        float axisVal = InputBridge.Instance.GetInputAxisValue(inputAxis[i]).x;

                        // Always take this value if our last entry was 0. 
                        if (lastVal == 0)
                        {
                            lastVal = axisVal;
                        }
                        else if (axisVal != 0 && axisVal > lastVal)
                        {
                            lastVal = axisVal;
                        }
                    }
                }

                // Check Unity Input Action
                if (RotateAction != null)
                {
                    float axisVal = RotateAction.action.ReadValue<Vector2>().x;
                    // Always take this value if our last entry was 0. 
                    if (lastVal == 0)
                    {
                        lastVal = axisVal;
                    }
                    else if (axisVal != 0 && axisVal > lastVal)
                    {
                        lastVal = axisVal;
                    }
                }

                return lastVal;
            }

            public virtual void DoSnapRotation(float xInput)
            {

                // Reset rotation amount before retrieving inputs
                rotationAmount = 0;

                // Snap Right
                if (xInput >= 0.1f && previousXInput < 0.1f)
                {
                    if(isGrab == true)
                    {
                        StickZippoClose();
                    }
                }
                // Snap Left
                else if (xInput <= -0.1f && previousXInput > -0.1f)
                {
                    if (isGrab == true)
                    {
                        StickZippoOpen();
                    }
                }

                if (Math.Abs(rotationAmount) > 0)
                {

                    // Call any Before Rotation Events
                    OnBeforeRotate?.Invoke();

                    // Apply rotation
                    transform.rotation = Quaternion.Euler(new Vector3(transform.eulerAngles.x, transform.eulerAngles.y + rotationAmount, transform.eulerAngles.z));

                    recentSnapTurnTime = Time.time;

                    // Call any After Rotation Events
                    OnAfterRotate?.Invoke();
                }
            }
    }
}